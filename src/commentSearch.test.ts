import * as assert from 'node:assert/strict';
import { test } from 'node:test';
import { extractSearchFields, findInFields } from './commentSearch';

function search(input: string, query: string, mode: 'comments' | 'commentsAndSource' = 'comments') {
  return findInFields(extractSearchFields(input), query, mode);
}

test('searches decoded UTF-8 and literal text in comments, case-insensitively', () => {
  const input = 'add comment="Hello \\D0\\9F\\D1\\80\\D0\\B8\\D0\\B2\\D0\\B5\\D1\\82 WAN" name="\\D0\\9F\\D1\\80"';
  const russian = search(input, 'привет');
  assert.equal(russian.length, 1);
  assert.equal(input.slice(russian[0].start, russian[0].end), '\\D0\\9F\\D1\\80\\D0\\B8\\D0\\B2\\D0\\B5\\D1\\82');
  assert.equal(search(input, 'hello').length, 1);
  assert.equal(search(input, 'wan').length, 1);
  assert.equal(search(input, 'имя').length, 0);
});

test('leading space also matches the start of a quoted comment but not a word suffix', () => {
  const input = 'add comment="LAN интерфейс"\nadd comment="HomeLAN интерфейс"\n'
    + 'add comment="Office LAN интерфейс"\nadd comment="\\4C\\41\\4E интерфейс"';
  const matches = search(input, ' lan');
  assert.deepEqual(matches.map(match => input.slice(match.start, match.end)), ['LAN', ' LAN', '\\4C\\41\\4E']);
  assert.deepEqual(matches.map(match => match.decodedLength), [3, 4, 3]);
  assert.equal(search(input, 'lan').length, 4);
  assert.equal(search(input, ' LAN').length, 3);
  assert.equal(search('add comment="LAN интерфейс"', ' ').length, 1);
  const script = 'add source=":log info \\"LAN интерфейс\\"; :log info \\"HomeLAN\\""';
  assert.equal(search(script, ' lan').length, 0);
  assert.equal(search(script, ' lan', 'commentsAndSource').length, 1);
});

test('finds mixed encoded and literal text across continued lines', () => {
  const input = 'add comment="test \\D0\\9F\\D1\\80\\D0\\B8\\D0\\B2\\D0\\B5\\D1\\82 \\D0\\\n    \\BC\\D0\\B8\\D1\\80"';
  const match = search(input, 'привет ми')[0];
  assert.ok(match);
  assert.equal(input.slice(match.start, match.end), '\\D0\\9F\\D1\\80\\D0\\B8\\D0\\B2\\D0\\B5\\D1\\82 \\D0\\\n    \\BC\\D0\\B8');
});

test('searches quoted comments following an assignment line continuation', () => {
  const input = 'add address=192.168.222.0/24 comment=\\\r\n    "\\D0\\94\\D0\\B8\\D0\\B0\\D0\\BF\\D0\\B0\\D0\\B7\\D0\\BE\\D0\\BD LAN" list=LAN_IP';
  const match = search(input, 'Диапазон LAN')[0];
  assert.ok(match);
  assert.equal(input.slice(match.start, match.end), '\\D0\\94\\D0\\B8\\D0\\B0\\D0\\BF\\D0\\B0\\D0\\B7\\D0\\BE\\D0\\BD LAN');
  assert.equal(search(input.replace(/\r/g, ''), 'диапазон').length, 1);
});

test('includes whole source only in combined mode and ignores field names inside strings', () => {
  const input = 'add comment="Router" source=":log info \\"comment=hidden\\" \\D0\\9F\\D1\\80"';
  assert.equal(search(input, 'пр').length, 0);
  assert.equal(search(input, 'пр', 'commentsAndSource').length, 1);
  assert.equal(search(input, 'hidden', 'commentsAndSource').length, 1);
  assert.equal(search(input, 'hidden').length, 0);
  assert.equal(extractSearchFields(input).length, 2);
});

test('finds matches in unquoted values and repeated occurrences', () => {
  assert.equal(search('add comment=hello name=foo comment="hello hello"', 'hello').length, 3);
});

test('does not interpret field names in top-level hash comments as assignments', () => {
  assert.equal(search('# comment="not a field"\nadd comment="real"', 'not a field').length, 0);
  assert.equal(search('# comment="not a field"\nadd comment="real"', 'real').length, 1);
});

test('handles invalid UTF-8 bytes without crashing', () => {
  assert.equal(search('add comment="\\FF text"', 'text').length, 1);
});

test('searches Cyrillic in both comments and source without local fixtures', () => {
  const input = 'add comment="\\D0\\9F\\D0\\BE\\D0\\B4\\D0\\BD\\D0\\B8\\D0\\BC\\D0\\B0\\D0\\B5\\D0\\BC WAN1" '
    + 'source=":log info \\"\\D0\\9F\\D0\\BE\\D0\\B4\\D0\\BD\\D0\\B8\\D0\\BC\\D0\\B0\\D0\\B5\\D0\\BC WAN1\\""';
  assert.equal(search(input, 'поднимаем WAN1').length, 1);
  assert.equal(search(input, 'поднимаем WAN1', 'commentsAndSource').length, 2);
});
