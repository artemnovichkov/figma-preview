//
//  Created by Artem Novichkov on 04.08.2026.
//

import SwiftUI

// Named `Preview` on purpose: Xcode discovers previews by parsing the source for a macro literally named
// `Preview`, so a custom name never shows up in the canvas. The `with:` label keeps these unambiguous
// against SwiftUI's `#Preview`.

@freestanding(declaration)
public macro Preview(_ name: String? = nil,
                     with image: Image,
                     previewState: PreviewState = .hidden,
                     @ViewBuilder body: @escaping @MainActor () -> any View) = #externalMacro(module: "FigmaPreviewMacros",
                                                                                              type: "FigmaPreviewMacro")

@freestanding(declaration)
public macro Preview(_ name: String? = nil,
                     with url: URL,
                     accessToken: String,
                     previewState: PreviewState = .hidden,
                     @ViewBuilder body: @escaping @MainActor () -> any View) = #externalMacro(module: "FigmaPreviewMacros",
                                                                                              type: "FigmaPreviewMacro")

@freestanding(declaration)
public macro Preview(_ name: String? = nil,
                     with fileID: String,
                     componentID: String,
                     accessToken: String,
                     previewState: PreviewState = .hidden,
                     @ViewBuilder body: @escaping @MainActor () -> any View) = #externalMacro(module: "FigmaPreviewMacros",
                                                                                              type: "FigmaPreviewMacro")
