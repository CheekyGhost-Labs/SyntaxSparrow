//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension SwitchExpression {

    struct SwitchCase: DeclarationComponent {

        // MARK: - Supplementary
        
        /// Enumeration of supported switch case label types.
        public enum Label: String, Equatable {
            /// Represents the `default` label prefix
            /// i.e `default:` and `@unknown default:`
            case `default`
            /// Represents the `case` label prefix
            /// i.e `case .member:` and `case let item as Value`
            case `case`

            // MARK: - CustomStringConvertible

            var description: String {
                "\(rawValue)"
            }
        }

        /// Supported attribute (if any) preceding the case declaration.
        ///
        /// i.e:
        /// ```swift
        /// @unknown default:
        /// ```
        /// would resolve the `@unknown` attribute.
        /// - See: ``SyntaxSparrow/Attribute``
        public var attribute: Attribute? { resolver.resolveAttribute() }

        /// Convenience getter for the underlying `label` property for the case.
        ///
        /// for example,
        /// ```swift
        /// case .example:
        /// default:
        /// ```
        /// - The first label would be `"case"`
        /// - The second label would be `"default"`
        public var label: Label { resolver.resolveLabel() }

        /// Array of items in the case declaration.
        ///
        /// for example:
        /// ```swift
        /// case .example:
        /// case let .example(name):
        /// case .example(let name, var age):
        /// case .example, .other:
        /// case let item as Thing:
        /// ```
        /// - The first case would be: `[.member("example", ["name"])]`
        /// - The second case would be: `[.valueBindingMember("example", ["name", "age"])]`
        /// - The third case would be: `[.innerValueBindingMember("example", ["let": "name", "var": "age"])]
        /// - The fourth cases would be: `[.member("example"), .member("other")]`
        /// - The fifth case would be: `[.valueBinding("let", ["item", "as", "Thing"])]`
        public var items: [Item] { resolver.resolveItems() }

        /// Array of code block statements within the switch case body.
        /// - See: ``SyntaxSparrow/CodeBlock/Statement``
        public var statements: [CodeBlock.Statement] { resolver.rsolveStatements() }

        // MARK: - Properties: DeclarationComponent

        public var node: SwitchCaseSyntax { resolver.node }

        // MARK: - Properties: DeclarationCollecting

        private(set) var resolver: SwitchExpressionCaseSemanticsResolver

        // MARK: - Lifecycle

        public init(node: SwitchCaseSyntax) {
            resolver = SwitchExpressionCaseSemanticsResolver(node: node)
        }
    }
}
