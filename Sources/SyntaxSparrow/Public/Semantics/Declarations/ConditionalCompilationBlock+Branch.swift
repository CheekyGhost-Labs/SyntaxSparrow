//
//  ConditionalCompilationBlock+Branch.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension ConditionalCompilationBlock {
    /// Represents a branch within a ``SyntaxSparrow/ConditionalCompilationBlock/Branch``.
    ///
    /// Each branch within a conditional compilation block starts with a keyword: `#if`, `#elseif`, or `#else`.
    /// A branch might also have a condition associated with the keyword, which determines whether
    /// the compiler will include the code within the branch during the compilation process.
    ///
    /// For example, in  the following declaration the block has two branches
    /// ```swift
    /// #if true
    /// enum A {}
    /// #else
    /// enum B {}
    /// #endif
    /// ```
    /// - The first branch has the keyword `#if` and the condition `true`
    /// - The second branch has the keyword `#else` and no condition
    ///
    /// Each instance of ``SyntaxSparrow/ConditionalCompilationBlock/Branch`` corresponds to a `IfConfigClauseSyntax` node in the Swift syntax tree.
    ///
    /// The `Branch` struct provides access to the keyword, the optional condition, and the source location of the branch.
    struct Branch: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {
        // MARK: - Supplementary

        private enum Constants {
            static let ifKeyword: String = "#if"
            static let elseIfKeyword: String = "#elseif"
            static let elseKeyword: String = "#else"
        }

        public enum Keyword: Equatable, Hashable {
            /// An `#if` branch.
            case `if`
            /// An `#elseif` branch.
            case elseif
            /// An `#else` branch.
            case `else`
            /// An unsupported or unknown keyword.
            /// This should never be reached but is to support any future changes without exploding
            case unsupported(keyword: String)

            // MARK: - Conformance: Hashable

            public func hash(into hasher: inout Hasher) {
                switch self {
                case .if:
                    hasher.combine(Constants.ifKeyword.hashValue)
                case .elseif:
                    hasher.combine(Constants.elseIfKeyword.hashValue)
                case .else:
                    hasher.combine(Constants.elseKeyword.hashValue)
                case let .unsupported(keyword):
                    hasher.combine(keyword.hashValue)
                }
            }
        }

        // MARK: - Properties: Declaration

        public var node: IfConfigClauseSyntax { resolver.node }

        // MARK: - Properties

        /// The branch keyword, either `"#if"`, `"#elseif"`, or `"#else"`.
        public var keyword: Keyword {
            let rawKeyword = resolver.keyword
            switch rawKeyword {
            case Constants.ifKeyword:
                return .if
            case Constants.elseIfKeyword:
                return .elseif
            case Constants.elseKeyword:
                return .else
            default:
                return .unsupported(keyword: rawKeyword)
            }
        }

        /// The branch condition (if any).
        ///
        /// This `condition` is present when the `keyword` is `#if` or `#elseif`, and `nil` when the `keyword` is `#else`.
        public var condition: String? { resolver.condition }

        // MARK: - Properties: SyntaxSourceLocationResolving

        public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

        // MARK: - Properties: DeclarationCollecting

        private(set) var resolver: ConditionalCompilationBlockBranchSemanticsResolver

        var declarationCollection: DeclarationCollection { resolver.declarationCollection }

        // MARK: - Lifecycle

        /// Creates a new ``SyntaxSparrow/ConditionalCompilationBlock/Branch`` instance from an `IfConfigClauseSyntax` node.
        public init(node: IfConfigClauseSyntax, context: SyntaxExplorerContext) {
            resolver = ConditionalCompilationBlockBranchSemanticsResolver(node: node, context: context)
            collectChildren()
        }

        // MARK: - Properties: Child Collection

        func collectChildren() {
            resolver.collectChildren()
        }
    }
}

extension ConditionalCompilationBlock.Branch: DeclarationCollecting {}
