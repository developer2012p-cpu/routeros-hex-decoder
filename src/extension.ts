import * as vscode from 'vscode';

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
      if (document.languageId !== 'routeros') {
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

  const toggleCommand = vscode.commands.registerCommand('routerosEncoding.toggle', () => {
    showDecoded = !showDecoded;
    vscode.window.showInformationMessage(
      `RouterOS Encoding: Inline display ${showDecoded ? 'ON' : 'OFF'}`
    );
    updateDecorations(vscode.window.activeTextEditor);
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
