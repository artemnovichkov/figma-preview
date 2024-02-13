
# Figma Preview

<p align="center"/>
  <img src=".github/preview.png"/>
</p>

Figma Preview is a Swift library designed to streamline the integration of Figma designs into your Xcode Preview. It allows developers to preview UI components directly from Figma files, facilitating a smoother design-to-code transition and ensuring that your app's UI matches the design specifications with precision.

## Features

- **Direct Preview:** Instantly preview Figma designs in your Xcode Preview.
- **Easy Integration:** Seamlessly integrates with Xcode, leveraging Swift Package Manager for straightforward installation.
- **Design Sync:** Keep your application's UI in sync with the latest design changes in Figma.

## Installation

### Swift Package Manager

You can add Figma Preview to an Xcode project by adding it as a package dependency.

1. From the File menu, select Swift Packages > Add Package Dependency...
2. Enter the package repository URL: `https://github.com/artemnovichkov/figma-preview.git`
3. Specify the version rules that make sense for your project.

## Usage

### Importing the Library

First, import FigmaPreview into your Swift file:

```swift
import FigmaPreview
```

### Example Usage

Here's 3 ways to use FigmaPreview to show a design component from Figma

1. Using local images:

```swift
#Preview {
    ContentView()
        .compare(with: Image(.component))
}
```

You can export final components in PNG format and save them to Preview Assets.xcassets. These assets will only be included in debug builds and removed once you create an archive of your app. You can learn more about development assets in [Build programmatic UI with Xcode Previews](https://developer.apple.com/videos/play/wwdc2023/10252) WWDC23 session.

2. Using URL for Figma component:

```swift
#Preview {
    ContentView()
        .compare(with: URL(string: "https://www.figma.com/file/<file-id>/Untitled?node-id=<component-id>")!)
        .environment(\.figmaAccessToken, "<figma-access-token>")
}
```

You can select a required component in Layers menu and copy a link via `Copy/Paste as > Copy link` menu.

3. Using File ID and Component ID for Figma component:

```swift
#Preview {
    ContentView()
        .compare(with: "<file-id>", componentID: "<component-id>")
        .environment(\.figmaAccessToken, "<figma-access-token>")
}
```

You can extract required IDs from Figma link.

If you're using Figma URLs or IDs, don't forget to generate a Figma Access Token via `Figma > Help and account > Account settings` menu:

<p align="center"/>
  <img src=".github/access-token.png"/>
</p>

## Preview Options

Figma Prview add a panel with preview options:

1. Hidden preview. The preview is hidden, you can check and update your view.
2. Layers. Adds the preview as an overlay with opacity configuration.
3. Compare. Adds the preview with a movable slider.

Check `FigmaPreviewExample` project to try it yourself.

## Contributing

I welcome contributions! If you would like to help improve Figma Preview, please submit a pull request or open an issue for discussion.

## Author

Artem Novichkov, https://www.artemnovichkov.com/about

## License

The project is available under the MIT license. See the [LICENSE](./LICENSE) file for more info.
