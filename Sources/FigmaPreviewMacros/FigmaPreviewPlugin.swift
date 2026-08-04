//
//  Created by Artem Novichkov on 04.08.2026.
//

import SwiftCompilerPlugin
import SwiftSyntaxMacros

@main
struct FigmaPreviewPlugin: CompilerPlugin {

    let providingMacros: [any Macro.Type] = [FigmaPreviewMacro.self]
}
