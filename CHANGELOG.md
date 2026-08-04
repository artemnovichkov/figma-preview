# Changelog

All notable changes to Figma Preview are documented in this file.

## 0.2.0 - 2026-08-04

### Added

- A `#Preview(with:)` macro for concise Figma comparisons on Xcode 15.3 and later.
- A `.figma` preview trait for composing Figma comparisons with standard preview traits on Xcode 16 and later.
- macOS 12 support.
- Macro expansion tests for local and remote previews.

### Fixed

- Remote macro previews now pass the Figma access token into the comparison view.
- The example project now resolves the local FigmaPreview package.
- Swift 6 concurrency safety for the Figma access-token environment key.
