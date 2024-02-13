//
//  Created by Artem Novichkov on 13.02.2024.
//

import SwiftUI

public extension View {

    func compare(with url: URL) -> some View {
        modifier(FigmaViewModifier(contentType: .url(url)))
    }

    func compare(with image: Image) -> some View {
        modifier(FigmaViewModifier(contentType: .image(image)))
    }

    func compare(with fileID: String, componentID: String) -> some View {
        modifier(FigmaViewModifier(contentType: .figma(fileID: fileID, componentID: componentID)))
    }
}
