# RouterOS Hex Decoder

VS Code extension for decoding RouterOS `\XX` hex-encoded UTF-8 sequences in `.rsc` configuration exports.

## Features

- **Hover Preview** — hover over any quoted string containing hex sequences to see the decoded UTF-8 text
- **Inline Decoration** — decoded text displayed inline before the closing quote (toggleable)
- **Multiline Support** — correctly handles RouterOS backslash-continued strings across multiple lines
- **Configurable** — customize hover title visibility and inline delimiters via Settings

## Keyboard Shortcuts

| Shortcut | Action |
|---|---|
| `Ctrl+Shift+R` | Toggle inline decoded text on/off |
| `Ctrl+Alt+R` | Toggle inline decoded text on/off (alternative) |

Both shortcuts are active only when editing `.rsc` files.

## Settings

Open **File → Preferences → Settings** and search for `RouterOS Hex Decoder`, or edit `settings.json` directly:

| Setting | Default | Description |
|---|---|---|
| `routerosHexDecoder.showHoverTitle` | `true` | Show "Decoded:" header in hover preview |
| `routerosHexDecoder.inlinePrefix` | ` (→ ` | Opening delimiter for inline decoded text |
| `routerosHexDecoder.inlineSuffix` | `)` | Closing delimiter for inline decoded text |

Changes apply immediately without reloading.

## Usage

1. Open any `.rsc` file in VS Code
2. Hover over hex-encoded strings (e.g., `"\D0\94\D0\B8\D0\B0\D0\BF\D0\B0\D0\B7\D0\BE\D0\BD LAN"`) to see decoded preview
3. Press `Ctrl+Shift+R` to toggle inline decoded text display
4. Customize appearance via Settings if needed

## Versioning

This project follows Semantic Versioning (`MAJOR.MINOR.PATCH`). See `VERSIONING.md` in the extension folder for details.

## License

Freeware. Free for personal and commercial use. No warranty provided.
