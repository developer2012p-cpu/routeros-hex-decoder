export type SearchMode = 'comments' | 'commentsAndSource';

export interface SearchBoundaryCharacters {
  leading: string;
  trailing: string;
}

export const DEFAULT_SEARCH_BOUNDARIES: SearchBoundaryCharacters = {
  leading: ' "\'([{=,:;.!?#',
  trailing: ' "\')]}=,:;.!?',
};

export interface SearchField {
  kind: 'comment' | 'source';
  text: string;
  positions: Array<{ start: number; end: number }>;
}

export interface SearchMatch {
  field: SearchField;
  start: number;
  end: number;
  decodedOffset: number;
  decodedLength: number;
}

interface BytePosition {
  byte: number;
  start: number;
  end: number;
}

const FIELD_PATTERN = /(?:comment|source)[ \t]*=[ \t]*/y;

function decodeValue(raw: string, offset: number, kind: SearchField['kind']): SearchField {
  const bytes: BytePosition[] = [];
  const encoder = new TextEncoder();

  for (let i = 0; i < raw.length;) {
    const start = i;
    let character: string;
    if (raw[i] === '\\' && i + 1 < raw.length) {
      const hex = raw.slice(i + 1, i + 3);
      if (/^[0-9a-fA-F]{2}$/.test(hex)) {
        bytes.push({ byte: parseInt(hex, 16), start: offset + i, end: offset + i + 3 });
        i += 3;
        continue;
      }
      const continued = /^\\[ \t]*\r?\n[ \t]*/.exec(raw.slice(i));
      if (continued) {
        i += continued[0].length;
        continue;
      }
      const escaped: Record<string, string> = { _: ' ', n: '\n', r: '\r', t: '\t', '"': '"', '\\': '\\', '$': '$' };
      if (Object.prototype.hasOwnProperty.call(escaped, raw[i + 1])) {
        character = escaped[raw[i + 1]];
        i += 2;
      } else {
        character = raw[i];
        i++;
      }
    } else {
      const codePoint = raw.codePointAt(i)!;
      character = String.fromCodePoint(codePoint);
      i += character.length;
    }
    for (const byte of encoder.encode(character)) {
      bytes.push({ byte, start: offset + start, end: offset + i });
    }
  }

  let text = '';
  const positions: SearchField['positions'] = [];
  for (let i = 0; i < bytes.length;) {
    const first = bytes[i].byte;
    const size = first < 0x80 ? 1 : first >= 0xc2 && first <= 0xdf ? 2
      : first >= 0xe0 && first <= 0xef ? 3 : first >= 0xf0 && first <= 0xf4 ? 4 : 1;
    let valid = size === 1 && first < 0x80;
    if (size > 1 && i + size <= bytes.length) {
      const second = bytes[i + 1].byte;
      valid = second >= 0x80 && second <= 0xbf
        && !(first === 0xe0 && second < 0xa0)
        && !(first === 0xed && second > 0x9f)
        && !(first === 0xf0 && second < 0x90)
        && !(first === 0xf4 && second > 0x8f)
        && bytes.slice(i + 2, i + size).every(({ byte }) => byte >= 0x80 && byte <= 0xbf);
    }
    const consumed = valid ? size : 1;
    const codePoint = !valid ? 0xfffd : size === 1 ? first : size === 2
      ? ((first & 0x1f) << 6) | (secondByte(bytes, i + 1) & 0x3f)
      : size === 3
        ? ((first & 0x0f) << 12) | ((secondByte(bytes, i + 1) & 0x3f) << 6) | (secondByte(bytes, i + 2) & 0x3f)
        : ((first & 0x07) << 18) | ((secondByte(bytes, i + 1) & 0x3f) << 12)
          | ((secondByte(bytes, i + 2) & 0x3f) << 6) | (secondByte(bytes, i + 3) & 0x3f);
    const decoded = String.fromCodePoint(codePoint);
    const position = { start: bytes[i].start, end: bytes[i + consumed - 1].end };
    text += decoded;
    for (let j = 0; j < decoded.length; j++) positions.push(position);
    i += consumed;
  }
  return { kind, text, positions };
}

function secondByte(bytes: BytePosition[], index: number): number {
  return bytes[index].byte;
}

export function extractSearchFields(input: string): SearchField[] {
  const fields: SearchField[] = [];
  for (let i = 0; i < input.length;) {
    if (input[i] === '#' && (i === 0 || input[i - 1] !== '\\')) {
      const newline = input.indexOf('\n', i);
      i = newline < 0 ? input.length : newline + 1;
      continue;
    }
    if (input[i] === '"') {
      i = skipQuoted(input, i);
      continue;
    }
    if (i > 0 && /[\w-]/.test(input[i - 1])) {
      i++;
      continue;
    }
    FIELD_PATTERN.lastIndex = i;
    const match = FIELD_PATTERN.exec(input);
    if (!match) {
      i++;
      continue;
    }
    const kind = match[0].startsWith('comment') ? 'comment' : 'source';
    let valueStart = FIELD_PATTERN.lastIndex;
    const continuation = /^\\[ \t]*\r?\n[ \t]*/.exec(input.slice(valueStart));
    if (continuation) valueStart += continuation[0].length;
    if (input[valueStart] === '"') {
      const end = skipQuoted(input, valueStart);
      const closed = input[end - 1] === '"' && end > valueStart + 1;
      fields.push(decodeValue(input.slice(valueStart + 1, closed ? end - 1 : end), valueStart + 1, kind));
      i = end;
    } else {
      let end = valueStart;
      while (end < input.length && !/\s/.test(input[end])) end++;
      fields.push(decodeValue(input.slice(valueStart, end), valueStart, kind));
      i = Math.max(end, valueStart + 1);
    }
  }
  return fields;
}

function skipQuoted(input: string, start: number): number {
  let i = start + 1;
  while (i < input.length) {
    if (input[i] === '\\' && i + 1 < input.length) {
      i += 2;
    } else if (input[i++] === '"') {
      break;
    }
  }
  return i;
}

export function findInFields(fields: SearchField[], query: string, mode: SearchMode,
  boundaries: SearchBoundaryCharacters = DEFAULT_SEARCH_BOUNDARIES): SearchMatch[] {
  if (!query) return [];
  const leadingSpace = query.startsWith(' ') && query.length > 1;
  const trailingSpace = query.endsWith(' ') && query.length > 1;
  const core = query.slice(leadingSpace ? 1 : 0, trailingSpace ? -1 : undefined);
  const searchText = core || query;
  const escaped = searchText.replace(/[.*+?^${}()|[\]\\]/g, '\\$&');
  const pattern = new RegExp(escaped, 'giu');
  const results: SearchMatch[] = [];
  for (const field of fields) {
    if (field.kind === 'source' && mode === 'comments') continue;
    for (const match of field.text.matchAll(pattern)) {
      let start = match.index;
      let end = start + match[0].length;
      if (core && leadingSpace) {
        if (start > 0 && boundaries.leading.includes(field.text[start - 1])) start--;
        else if (start !== 0) continue;
      }
      if (core && trailingSpace) {
        if (end < field.text.length && boundaries.trailing.includes(field.text[end])) end++;
        else if (end !== field.text.length) continue;
      }
      results.push({ field, start: field.positions[start].start, end: field.positions[end - 1].end,
        decodedOffset: start, decodedLength: end - start });
    }
  }
  return results.sort((a, b) => a.start - b.start);
}
