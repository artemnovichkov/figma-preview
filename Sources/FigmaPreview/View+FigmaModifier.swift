//
//  Created by Artem Novichkov on 13.02.2024.
//

import SwiftUI

public extension View {

    func compare(with url: URL, previewState: PreviewState = .hidden) -> some View {
        modifier(FigmaViewModifier(contentType: .url(url), 
                                   previewState: previewState))
    }

    func compare(with image: Image, previewState: PreviewState = .hidden) -> some View {
        modifier(FigmaViewModifier(contentType: .image(image), 
                                   previewState: previewState))
    }

    func compare(with fileID: String, componentID: String, previewState: PreviewState = .hidden) -> some View {
        modifier(FigmaViewModifier(contentType: .figma(fileID: fileID, componentID: componentID),
                                   previewState: previewState))
    }
}
