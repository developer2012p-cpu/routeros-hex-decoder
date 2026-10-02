import * as vscode from 'vscode';
import { DEFAULT_SEARCH_BOUNDARIES, extractSearchFields, findInFields, SearchMatch, SearchMode } from './commentSearch';

const HEX_PATTERN = /\\([0-9A-Fa-f]{2})/g;
// Matches quoted strings that may span multiple lines with backslash continuation
const QUOTED_STRING_PATTERN = /"([^"\\]*(?:\\[\s\S][^"\\]*)*)"/g;

function decodeRouterOSHex(text: string): string {
  // Join backslash-continued lines: remove trailing \ + newline + leading whitespace
  const joined = text.replace(/\\\s*\n\s*/g, '');

  const bytes: number[] = [];
  let lastIndex = 0;
  let match;

  HEX_PATTERN.lastIndex = 0;
  while ((match = HEX_PATTERN.exec(joined)) !== null) {
    for (let i = lastIndex; i < match.index; i++) {
      bytes.push(joined.charCodeAt(i));
    }
    bytes.push(parseInt(match[1], 16));
    lastIndex = match.index + match[0].length;
  }
  for (let i = lastIndex; i < joined.length; i++) {
    bytes.push(joined.charCodeAt(i));
  }

  return new TextDecoder('utf-8').decode(new Uint8Array(bytes));
}

function encodeToRouterOSHex(text: string): string {
  const bytes = new TextEncoder().encode(text);
  let result = '';
  for (const b of bytes) {
    if (b > 127) {
      result += '\\' + b.toString(16).toUpperCase().padStart(2, '0');
    } else {
      result += String.fromCharCode(b);
    }
  }
  return result;
}

function hasHexSequences(text: string): boolean {
  HEX_PATTERN.lastIndex = 0;
  return HEX_PATTERN.test(text);
}

function getConfig() {
  const cfg = vscode.workspace.getConfiguration('routerosHexDecoder');
  return {
    showHoverTitle: cfg.get<boolean>('showHoverTitle', true),
    inlinePrefix: cfg.get<string>('inlinePrefix', ' (→ '),
    inlineSuffix: cfg.get<string>('inlineSuffix', ')'),
  };
}

export function activate(context: vscode.ExtensionContext) {
  const decorationType = vscode.window.createTextEditorDecorationType({
    after: {
      margin: '0 0 0 1em',
      color: '#888888',
      fontStyle: 'italic',
    },
    rangeBehavior: vscode.DecorationRangeBehavior.ClosedClosed,
  });

  let showDecoded = true;
  let showHover = true;

  function updateDecorations(editor: vscode.TextEditor | undefined) {
    if (!editor || !showDecoded) {
      editor?.setDecorations(decorationType, []);
      return;
    }

    const document = editor.document;
    if (document.languageId !== 'routeros') {
      return;
    }

    const decorations: vscode.DecorationOptions[] = [];
    const text = document.getText();

    let match;
    QUOTED_STRING_PATTERN.lastIndex = 0;
    while ((match = QUOTED_STRING_PATTERN.exec(text)) !== null) {
      const quotedContent = match[1];
      if (hasHexSequences(quotedContent)) {
        const decoded = decodeRouterOSHex(quotedContent);
        // Show only first line inline to avoid breaking layout; full text available via hover
        const firstLine = decoded.split('\n')[0];
        const displayText = decoded.includes('\n') || firstLine.length > 80
          ? firstLine.substring(0, 77) + '...'
          : firstLine;
        // Position decoration right before the closing quote for better readability
        const closingQuotePos = document.positionAt(match.index + match[0].length - 1);
        const config = getConfig();
        decorations.push({
          range: new vscode.Range(closingQuotePos, closingQuotePos),
          renderOptions: {
            before: { contentText: `${config.inlinePrefix}${displayText}${config.inlineSuffix}` },
          },
        });
      }
    }

    editor.setDecorations(decorationType, decorations);
  }

  const hoverProvider: vscode.HoverProvider = {
    provideHover(document, position) {
      if (!showHover || document.languageId !== 'routeros') {
        return;
      }

      // Multiline-aware regex for quoted strings with backslash continuation
      const multilineQuoteRegex = /"([^"\\]*(?:\\[\s\S][^"\\]*)*)"/g;
      const lineText = document.getText(new vscode.Range(
        new vscode.Position(Math.max(0, position.line - 50), 0),
        new vscode.Position(Math.min(document.lineCount - 1, position.line + 50), Number.MAX_SAFE_INTEGER)
      ));
      
      let foundMatch: RegExpExecArray | null = null;
      let matchOffset = 0;
      multilineQuoteRegex.lastIndex = 0;
      let m;
      while ((m = multilineQuoteRegex.exec(lineText)) !== null) {
        const absStart = document.offsetAt(new vscode.Position(Math.max(0, position.line - 50), 0)) + m.index;
        const absEnd = absStart + m[0].length;
        const posOffset = document.offsetAt(position);
        if (posOffset >= absStart && posOffset <= absEnd) {
          foundMatch = m;
          matchOffset = absStart;
          break;
        }
      }
      
      if (!foundMatch) {
        return;
      }

      const wordRange = new vscode.Range(
        document.positionAt(matchOffset),
        document.positionAt(matchOffset + foundMatch[0].length)
      );
      const inner = foundMatch[1];

      if (!hasHexSequences(inner)) {
        return;
      }

      const decoded = decodeRouterOSHex(inner);

      const md = new vscode.MarkdownString();
      const config = getConfig();
      if (config.showHoverTitle) {
        md.appendMarkdown('**Decoded:**');
        md.appendText('\n' + decoded);
      } else {
        md.appendText(decoded);
      }

      return new vscode.Hover(md, wordRange);
    },
  };

  const searchCommand = vscode.commands.registerCommand('routerosEncoding.searchComments', () => {
    const editor = vscode.window.activeTextEditor;
    if (!editor || editor.document.languageId !== 'routeros') {
      vscode.window.showInformationMessage('Open a RouterOS .rsc file to search comments.');
      return;
    }

    let mode: SearchMode = 'commentsAndSource';
    const scopeButton: vscode.QuickInputButton = {
      iconPath: new vscode.ThemeIcon('filter'),
      tooltip: 'Search comments and scripts — click to search comments only',
    };
    const document = editor.document;
    let indexedVersion = -1;
    let fields: ReturnType<typeof extractSearchFields> = [];
    const picker = vscode.window.createQuickPick<vscode.QuickPickItem & { match: SearchMatch }>();
    picker.placeholder = 'Find text in comments and scripts (click filter to change scope)';
    picker.buttons = [scopeButton];
    picker.matchOnDescription = true;
    picker.matchOnDetail = false;
    const update = () => {
      const query = picker.value;
      if (!query) {
        picker.items = [];
        picker.title = mode === 'commentsAndSource' ? 'Search comments and scripts' : 'Search comments only';
        return;
      }
      if (document.version !== indexedVersion) {
        fields = extractSearchFields(document.getText());
        indexedVersion = document.version;
      }
      const config = vscode.workspace.getConfiguration('routerosHexDecoder', document.uri);
      const matches = findInFields(fields, query, mode, {
        leading: config.get('searchLeadingCharacters', DEFAULT_SEARCH_BOUNDARIES.leading),
        trailing: config.get('searchTrailingCharacters', DEFAULT_SEARCH_BOUNDARIES.trailing),
      });
      picker.items = matches.map(match => {
        const line = document.positionAt(match.start).line + 1;
        const preview = match.field.text.slice(Math.max(0, match.decodedOffset - 30),
          match.decodedOffset + match.decodedLength + 50).replace(/\s+/g, ' ');
        return {
          label: `${match.field.kind} · line ${line}`,
          description: preview,
          alwaysShow: true,
          match,
        };
      });
      picker.title = `${mode === 'commentsAndSource' ? 'Comments and scripts' : 'Comments only'} · ${matches.length} result${matches.length === 1 ? '' : 's'}`;
    };
    picker.onDidTriggerButton(button => {
      if (button !== scopeButton) return;
      mode = mode === 'commentsAndSource' ? 'comments' : 'commentsAndSource';
      picker.placeholder = mode === 'commentsAndSource'
        ? 'Find text in comments and scripts (click filter to change scope)'
        : 'Find text in comments only (click filter to include scripts)';
      update();
    });
    picker.onDidChangeValue(update);
    const searchSettingsListener = vscode.workspace.onDidChangeConfiguration(e => {
      if (e.affectsConfiguration('routerosHexDecoder.searchLeadingCharacters', document.uri)
        || e.affectsConfiguration('routerosHexDecoder.searchTrailingCharacters', document.uri)) update();
    });
    const documentListener = vscode.workspace.onDidChangeTextDocument(e => {
      if (e.document === document) update();
    });
    picker.onDidAccept(() => {
      const selected = picker.selectedItems[0];
      if (!selected) return;
      const range = new vscode.Range(document.positionAt(selected.match.start), document.positionAt(selected.match.end));
      editor.selection = new vscode.Selection(range.start, range.end);
      editor.revealRange(range, vscode.TextEditorRevealType.InCenter);
      picker.hide();
    });
    picker.onDidHide(() => {
      searchSettingsListener.dispose();
      documentListener.dispose();
      picker.dispose();
    });
    picker.show();
  });

  const toggleCommand = vscode.commands.registerCommand('routerosEncoding.toggle', () => {
    showDecoded = !showDecoded;
    vscode.window.showInformationMessage(
      `RouterOS Encoding: Inline display ${showDecoded ? 'ON' : 'OFF'}`
    );
    updateDecorations(vscode.window.activeTextEditor);
  });

  const toggleHoverCommand = vscode.commands.registerCommand('routerosEncoding.toggleHover', () => {
    showHover = !showHover;
    vscode.window.showInformationMessage(
      `RouterOS Encoding: Hover preview ${showHover ? 'ON' : 'OFF'}`
    );
  });

  const configListener = vscode.workspace.onDidChangeConfiguration((e) => {
    if (
      e.affectsConfiguration('routerosHexDecoder.inlinePrefix') ||
      e.affectsConfiguration('routerosHexDecoder.inlineSuffix') ||
      e.affectsConfiguration('routerosHexDecoder.showHoverTitle')
    ) {
      for (const ed of vscode.window.visibleTextEditors) {
        updateDecorations(ed);
      }
    }
  });

  context.subscriptions.push(
    decorationType,
    toggleCommand,
    toggleHoverCommand,
    searchCommand,
    configListener,
    vscode.languages.registerHoverProvider('routeros', hoverProvider),
    vscode.window.onDidChangeActiveTextEditor(updateDecorations),
    vscode.workspace.onDidChangeTextDocument((e) => {
      if (e.document === vscode.window.activeTextEditor?.document) {
        updateDecorations(vscode.window.activeTextEditor);
      }
    })
  );

  updateDecorations(vscode.window.activeTextEditor);
}

export function deactivate() {}
