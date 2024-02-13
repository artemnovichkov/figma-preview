//
//  Created by Artem Novichkov on 12.02.2024.
//

import SwiftUI
import FigmaPreview

struct ContentView: View {

    var body: some View {
        ZStack {
            LinearGradient(colors: [.red, .green],
                           startPoint: .leading,
                           endPoint: .trailing)
            Text("🥲")
                .font(.system(size: 40))
        }
    }
}

#Preview {
    ContentView()
        .frame(width: 400, height: 100)
        .compare(with: Image(.component), previewState: .compare)
}
