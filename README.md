# RouterOS Hex Decoder

VS Code extension for decoding RouterOS `\XX` hex-encoded UTF-8 sequences in `.rsc` configuration exports.

## Features

- **Hover Preview** — hover over any quoted string containing hex sequences to see the decoded UTF-8 text (toggleable)
- **Inline Decoration** — decoded text displayed inline before the closing quote (toggleable)
- **Multiline Support** — correctly handles RouterOS backslash-continued strings across multiple lines
- **Comment Search** — search decoded UTF-8 text in `comment=` values, optionally including the entire text of `source=` scripts in the current `.rsc` file
- **Configurable** — customize hover title visibility and inline delimiters via Settings

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+Alt+R` | Toggle hover preview on/off |
| `Ctrl+Alt+D` | Toggle inline decoded text on/off |
| `Ctrl+Alt+F` | Find text in decoded comments and scripts (switch scope using the filter button) |

These shortcuts are active only when editing `.rsc` files.

## Settings

Open **File → Preferences → Settings** and search for `RouterOS Hex Decoder`, or edit `settings.json` directly:

| Setting | Default | Description |
|---|---|---|
| `routerosHexDecoder.showHoverTitle` | `true` | Show "Decoded:" header in hover preview |
| `routerosHexDecoder.inlinePrefix` | ` (→ ` | Opening delimiter for inline decoded text |
| `routerosHexDecoder.inlineSuffix` | `)` | Closing delimiter for inline decoded text |
| `routerosHexDecoder.searchLeadingCharacters` | space, `"'([{=,:;.!?#` | Characters treated as a space before the searched text |
| `routerosHexDecoder.searchTrailingCharacters` | space, `"')]}=,:;.!?` | Characters treated as a space after the searched text |

The start and end of a value also count as boundaries, even if you remove all characters from these lists. Change the two lists independently in **File → Preferences → Settings**; each character in a list is an alternative to a query-edge space, not a sequence to match.

Changes apply immediately without reloading.

## Usage

1. Open any `.rsc` file in VS Code
2. Hover over hex-encoded strings (e.g., `"\D0\94\D0\B8\D0\B0\D0\BF\D0\B0\D0\B7\D0\BE\D0\BD LAN"`) to see decoded preview
3. Press `Ctrl+Alt+R` to toggle hover previews or `Ctrl+Alt+D` to toggle inline decoded text display
4. Run **RouterOS HD: Find Text in Comments** from the Command Palette (`Ctrl+Shift+P`) or press `Ctrl+Alt+F`, then type a query. Search includes both `comment=` and the entire `source=` text by default. Click the filter button in the search box to switch to comments only (or back) without clearing the query. Select a result to highlight its exact source bytes (including `\XX` sequences). Search is case-insensitive and covers only the active `.rsc` file; scripts include all text, not only `#` comments. A leading or trailing space in the query matches a configurable delimiter or the start/end of a value. For example, ` lan ` finds `comment="LAN"`, `comment="[LAN="`, and `comment="LAN)"`, but not `comment="HomeLAN"` or `comment="LAN-222"`. Delimiters actually present in a match are included in the highlighted result; literal query characters remain literal (` lan=` requires `=`). Configure leading and trailing delimiter characters separately under **File → Preferences → Settings** using **RouterOS Hex Decoder: Search Leading Characters** and **Search Trailing Characters**.
5. Customize appearance via Settings if needed

## Changelog

See [CHANGELOG.md](./CHANGELOG.md) for release history.

## Versioning

This project follows Semantic Versioning (`MAJOR.MINOR.PATCH`). See `VERSIONING.md` in the extension folder for details.

## License

Freeware. Free for personal and commercial use. No warranty provided.
