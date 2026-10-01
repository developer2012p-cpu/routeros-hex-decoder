# Versioning Policy

This project follows [Semantic Versioning](https://semver.org/) (`MAJOR.MINOR.PATCH`).

## Format

- **MAJOR** — incompatible changes to extension behavior or settings schema
- **MINOR** — new features, new settings, backward-compatible improvements
- **PATCH** — bug fixes, documentation corrections, packaging fixes

Increment the appropriate version component in `package.json` and `package-lock.json` **before packaging a changed release**. In particular, a bug fix after building `0.3.0` must be packaged as `0.3.1`; never overwrite an existing versioned VSIX with different contents. Ordinary local compilation or test runs do not create a new release and do not require a version bump.

## Release Naming

- The extension version in `package.json` uses `MAJOR.MINOR.PATCH` (for example, `0.3.0`).
- Git release tags use `vMAJOR.MINOR.PATCH` (for example, `v0.3.0`).
- VSIX files use `routeros-hex-decoder-MAJOR.MINOR.PATCH.vsix` **without** the `v` (for example, `routeros-hex-decoder-0.3.0.vsix`). This applies to local builds, GitHub Actions artifacts and releases, and the file published to VS Code Marketplace.
- The release workflow reads the version from `package.json` for the VSIX filename and checks that a release tag matches it. For a local build, run `npx --yes @vscode/vsce package --out routeros-hex-decoder-<version>.vsix` with the same version.

## Current Status

- `0.x.y` — early development, features may change between minor releases
- `1.0.0` — first stable release (planned when core functionality is considered complete)

## License

Freeware. Free for personal and commercial use. No warranty provided.
