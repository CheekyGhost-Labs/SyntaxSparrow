//
//  ConditionalCompilationBlock+Branch.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension ConditionalCompilationBlock {

    /// Struct representing a `ConditionalCompilationBlock` branch.
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
    struct Branch: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving, Equatable, Hashable, CustomStringConvertible {

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
            case `elseif`
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
                case .unsupported(let keyword):
                    hasher.combine(keyword.hashValue)
                }
            }
        }

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

        public init(node: IfConfigClauseSyntax, context: SyntaxExplorerContext) {
            self.resolver = ConditionalCompilationBlockBranchSemanticsResolver(node: node, context: context)
            collectChildren()
        }

        // MARK: - Properties: Child Collection

        func collectChildren() {
            resolver.collectChildren()
        }

        // MARK: - Equatable

        public static func == (lhs: Branch, rhs: Branch) -> Bool {
            return lhs.description == rhs.description
        }

        // MARK: - Hashable

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(description.hashValue)
        }

        // MARK: - CustomStringConvertible

        public var description: String {
            resolver.node.description.trimmed
        }
    }
}

extension ConditionalCompilationBlock.Branch: DeclarationCollecting {}
