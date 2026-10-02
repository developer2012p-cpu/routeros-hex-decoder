# Changelog

All notable changes to this project are documented here.

## [0.4.2] - 2026-10-02

### Changed
- Treat `#` as a leading search boundary by default; document the search boundary settings in the Settings table.

## [0.4.1] - 2026-10-02

### Added
- Configure leading and trailing search boundary characters separately in Settings; spaces at the edges of a query also match value boundaries and configured delimiters.

## [0.4.0] - 2026-10-02

### Added
- Toggle hover previews with `Ctrl+Alt+R` in RouterOS files.

### Changed
- Move the inline decoded text shortcut to `Ctrl+Alt+D` and remove `Ctrl+Shift+R`.

## [0.3.4] - 2026-10-02

### Added
- Search queries beginning with a space can match text immediately after the opening quote of a value. For example, ` lan` matches `comment="LAN интерфейс"`, but not `comment="HomeLAN интерфейс"`.

## [0.3.3] - 2026-07-01

### Added
- Search decoded UTF-8 text in `comment=` values, with an option to include the full text of `source=` scripts.
- Search RouterOS scripts and comments case-insensitively, including UTF-8 represented by `\XX` byte sequences.
- Navigate to search results and highlight the corresponding source text.
- Package versioned VSIX files and publish GitHub releases and the extension to the VS Code Marketplace from version tags.

### Improved
- Decode UTF-8 sequences across continued lines and handle invalid UTF-8 bytes safely during search.
- Exclude strings, including quoted script content, when identifying comment and source assignments.

## [0.2.2] - 2025-06-20

### Added
- Hover previews for decoded RouterOS hexadecimal UTF-8 strings.
- Toggleable inline display of decoded text in the editor.
- Support for multiline, backslash-continued quoted strings.
- Settings for hover title visibility and inline decoration delimiters.

### Improved
- Decode RouterOS `\XX` byte sequences as UTF-8 for editor previews.

[0.4.2]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.4.2
[0.4.1]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.4.1
[0.4.0]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.4.0
[0.3.4]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.3.4
[0.3.3]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.3.3
[0.2.2]: https://github.com/developer2012p-cpu/routeros-hex-decoder/releases/tag/v0.2.2
