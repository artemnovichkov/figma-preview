import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(FigmaPreviewMacros)
import FigmaPreviewMacros

private let testMacros: [String: Macro.Type] = [
    "Preview": FigmaPreviewMacro.self,
]

final class FigmaPreviewMacroTests: XCTestCase {

    func testImagePreviewWithoutName() {
        assertMacroExpansion(
            """
            #Preview(with: Image(.component)) {
                ContentView()
            }
            """,
            expandedSource:
            """
            @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
            nonisolated struct __macro_local_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
                static var fileID: String {
                    "FigmaPreviewMacrosTests/FigmaPreviewMacroTests.swift"
                }
                static var line: Int {
                    1
                }
                static var column: Int {
                    1
                }

                @MainActor static func makePreview() throws -> DeveloperToolsSupport.Preview {
                    DeveloperToolsSupport.Preview {
                        func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
                            body()
                        }
                        return __b_buildView {
                            ContentView()
                        }
                        .compare(with: Image(.component))
                    }
                }
            }
            """,
            macros: testMacros,
            testModuleName: "FigmaPreviewMacrosTests",
            testFileName: "FigmaPreviewMacroTests.swift"
        )
    }

    func testURLPreviewWithNameAndState() {
        assertMacroExpansion(
            """
            #Preview(
                "Remote",
                with: componentURL,
                accessToken: token,
                previewState: .layers,
            ) {
                ContentView()
            }
            """,
            expandedSource:
            """
            @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
            nonisolated struct __macro_local_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
                static var fileID: String {
                    "FigmaPreviewMacrosTests/FigmaPreviewMacroTests.swift"
                }
                static var line: Int {
                    1
                }
                static var column: Int {
                    1
                }

                @MainActor static func makePreview() throws -> DeveloperToolsSupport.Preview {
                    DeveloperToolsSupport.Preview("Remote") {
                        func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
                            body()
                        }
                        return __b_buildView {
                            ContentView()
                        }
                        .compare(
                            with: componentURL,
                            previewState: .layers)
                        .environment(\\.figmaAccessToken, token)
                    }
                }
            }
            """,
            macros: testMacros,
            testModuleName: "FigmaPreviewMacrosTests",
            testFileName: "FigmaPreviewMacroTests.swift"
        )
    }

    func testFileAndComponentIDsPreserveLocationAndMultipleViews() {
        assertMacroExpansion(
            """
            let marker = 0

            #Preview(
                with: "file-id",
                componentID: "1:2",
                accessToken: token,
                previewState: .compare
            ) {
                Text("First")
                Text("Second")
            }
            """,
            expandedSource:
            """
            let marker = 0

            @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, watchOS 10.0, *)
            nonisolated struct __macro_local_15PreviewRegistryfMu_: DeveloperToolsSupport.PreviewRegistry {
                static var fileID: String {
                    "FigmaPreviewMacrosTests/FigmaPreviewMacroTests.swift"
                }
                static var line: Int {
                    3
                }
                static var column: Int {
                    1
                }

                @MainActor static func makePreview() throws -> DeveloperToolsSupport.Preview {
                    DeveloperToolsSupport.Preview {
                        func __b_buildView(@SwiftUI.ViewBuilder body: () -> any SwiftUI.View) -> any SwiftUI.View {
                            body()
                        }
                        return __b_buildView {
                            Text("First")
                            Text("Second")
                        }
                        .compare(
                            with: "file-id",
                            componentID: "1:2",
                            previewState: .compare)
                        .environment(\\.figmaAccessToken, token)
                    }
                }
            }
            """,
            macros: testMacros,
            testModuleName: "FigmaPreviewMacrosTests",
            testFileName: "FigmaPreviewMacroTests.swift"
        )
    }

    func testMissingBodyDiagnostic() {
        assertMacroExpansion(
            "#Preview(with: Image(.component))",
            expandedSource: "",
            diagnostics: [
                DiagnosticSpec(
                    message: "#Preview requires a trailing closure with the previewed view",
                    line: 1,
                    column: 1
                ),
            ],
            macros: testMacros
        )
    }
}
#else
final class FigmaPreviewMacroTests: XCTestCase {

    func testMacroSupportRequiresHostPlatform() throws {
        throw XCTSkip("Macros are only supported when running tests for the host platform")
    }
}
#endif
