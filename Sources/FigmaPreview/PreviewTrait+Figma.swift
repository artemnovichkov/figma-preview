//
//  Created by Artem Novichkov on 04.08.2026.
//

#if compiler(>=6.0)
import Foundation
import SwiftUI

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
public extension PreviewTrait where T == Preview.ViewTraits {

    @MainActor
    static func figma(_ image: Image, previewState: PreviewState = .hidden) -> Self {
        .modifier(
            FigmaPreviewModifier(
                contentType: .image(image),
                previewState: previewState
            )
        )
    }

    @MainActor
    static func figma(_ url: URL,
                      accessToken: String,
                      previewState: PreviewState = .hidden) -> Self {
        .modifier(
            FigmaPreviewModifier(
                contentType: .url(url),
                previewState: previewState,
                accessToken: accessToken
            )
        )
    }

    @MainActor
    static func figma(fileID: String,
                      componentID: String,
                      accessToken: String,
                      previewState: PreviewState = .hidden) -> Self {
        .modifier(
            FigmaPreviewModifier(
                contentType: .figma(fileID: fileID, componentID: componentID),
                previewState: previewState,
                accessToken: accessToken
            )
        )
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
private struct FigmaPreviewModifier: PreviewModifier {

    let contentType: FigmaViewModifier.ContentType
    let previewState: PreviewState
    let accessToken: String?

    init(contentType: FigmaViewModifier.ContentType,
         previewState: PreviewState,
         accessToken: String? = nil) {
        self.contentType = contentType
        self.previewState = previewState
        self.accessToken = accessToken
    }

    func body(content: Content, context: Void) -> some View {
        content
            .modifier(
                FigmaViewModifier(
                    contentType: contentType,
                    previewState: previewState
                )
            )
            .transformEnvironment(\.figmaAccessToken) { value in
                if let accessToken {
                    value = accessToken
                }
            }
    }
}
#endif
