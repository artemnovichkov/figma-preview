//
//  Created by Artem Novichkov on 04.08.2026.
//

import SwiftBasicFormat
import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

/// Expands into a `DeveloperToolsSupport.PreviewRegistry` conformance, matching the code `#Preview` generates,
/// with the `compare(with:previewState:)` modifier applied to the preview body.
public struct FigmaPreviewMacro: DeclarationMacro {

    public static func expansion(of node: some FreestandingMacroExpansionSyntax,
                                 in context: some MacroExpansionContext) throws -> [DeclSyntax] {
        guard let body = node.trailingClosure else {
            context.diagnose(Diagnostic(node: Syntax(node), message: ExpansionDiagnostic.missingBody))
            return []
        }
        guard let location = context.location(of: node,
                                              at: .afterLeadingTrivia,
                                              filePathMode: .fileID) else {
            context.diagnose(Diagnostic(node: Syntax(node), message: ExpansionDiagnostic.missingLocation))
            return []
        }

        let arguments = parseArguments(node.arguments)
        let previewInitializer = makePreviewInitializer(name: arguments.previewName)
        let registry = context.makeUniqueName("PreviewRegistry")
        return [makePreviewDeclaration(registry: registry,
                                       location: location,
                                       initializer: previewInitializer,
                                       body: body,
                                       compareArguments: arguments.compareArguments,
                                       accessToken: arguments.accessToken)]
    }

    private static func parseArguments(_ arguments: LabeledExprListSyntax) -> ParsedArguments {
        // SwiftSyntax 510 represents a trailing comma as an extra missing argument.
        // Ignore it so removing accessToken never leaves an invalid empty call argument.
        var remainingArguments = Array(arguments).filter { !$0.expression.trimmedDescription.isEmpty }
        let previewName: ExprSyntax?

        if let firstArgument = remainingArguments.first, firstArgument.label == nil {
            previewName = firstArgument.expression.trimmed
            remainingArguments.removeFirst()
        } else {
            previewName = nil
        }

        let accessTokenIndex = remainingArguments.firstIndex { $0.label?.text == "accessToken" }
        let accessToken = accessTokenIndex.map { remainingArguments.remove(at: $0).expression.trimmed }

        return ParsedArguments(previewName: previewName,
                               compareArguments: normalizedArguments(remainingArguments),
                               accessToken: accessToken)
    }

    private static func normalizedArguments(_ arguments: [LabeledExprSyntax]) -> LabeledExprListSyntax {
        let lastIndex = arguments.indices.last
        return LabeledExprListSyntax(arguments.indices.map { index in
            let trailingComma: TokenSyntax? = index == lastIndex ? nil : .commaToken(trailingTrivia: .space)
            let argument = arguments[index]
            return LabeledExprSyntax(label: argument.label,
                                     colon: argument.colon,
                                     expression: argument.expression,
                                     trailingComma: trailingComma)
        })
    }

    private static func makePreviewInitializer(name: ExprSyntax?) -> ExprSyntax {
        guard let name else {
            return "DeveloperToolsSupport.Preview"
        }
        return "DeveloperToolsSupport.Preview(\(name))"
    }

    private static func makePreviewDeclaration(registry: TokenSyntax,
                                               location: AbstractSourceLocation,
                                               initializer: ExprSyntax,
                                               body: ClosureExprSyntax,
                                               compareArguments: LabeledExprListSyntax,
                                               accessToken: ExprSyntax?) -> DeclSyntax {
        let previewBody = makePreviewBody(body: body,
                                          compareArguments: compareArguments,
                                          accessToken: accessToken)
        // Neutral indentation lets BasicFormat correctly indent syntax interpolated from the call site.
        let declaration: DeclSyntax =
            """
            @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
            nonisolated struct \(registry): DeveloperToolsSupport.PreviewRegistry {
            static var fileID: String {
            \(location.file)
            }
            static var line: Int {
            \(location.line)
            }
            static var column: Int {
            \(location.column)
            }

            @MainActor static func makePreview() throws -> DeveloperToolsSupport.Preview {
            \(initializer) {
            func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
            body()
            }
            return \(previewBody)
            }
            }
            }
            """
        return declaration.formatted().cast(DeclSyntax.self)
    }

    private static func makePreviewBody(body: ClosureExprSyntax,
                                        compareArguments: LabeledExprListSyntax,
                                        accessToken: ExprSyntax?) -> ExprSyntax {
        let comparison: ExprSyntax =
            """
            __b_buildView \(body)
            .compare(\(compareArguments))
            """
        guard let accessToken else {
            return comparison
        }
        return
            """
            \(comparison)
            .environment(\\.figmaAccessToken, \(accessToken))
            """
    }

    private struct ParsedArguments {

        let previewName: ExprSyntax?
        let compareArguments: LabeledExprListSyntax
        let accessToken: ExprSyntax?
    }

    private enum ExpansionDiagnostic: String, DiagnosticMessage {
        case missingBody
        case missingLocation

        var message: String {
            switch self {
            case .missingBody:
                "#Preview requires a trailing closure with the previewed view"
            case .missingLocation:
                "#Preview failed to resolve its source location"
            }
        }

        var diagnosticID: MessageID {
            MessageID(domain: "FigmaPreviewMacro", id: rawValue)
        }

        var severity: DiagnosticSeverity { .error }
    }
}
