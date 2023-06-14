//
//  CodeBlock+Statement.swift
//
//
//  Created by Michael O'Brien on 14/6/2023.
//

import Foundation
import SwiftSyntax

public extension CodeBlock {
    struct Statement: DeclarationComponent {
        // MARK: - Kind

        public enum Kind: Equatable {
            case declaration(DeclSyntax) // decl
            case statement(StmtSyntax) // stmt
            case expression(ExprSyntax) // expr

            public static func == (lhs: Kind, rhs: Kind) -> Bool {
                switch (lhs, rhs) {
                case let (.declaration(lhsNode), .declaration(rhsNode)):
                    return lhsNode.id == rhsNode.id
                case let (.statement(lhsNode), .statement(rhsNode)):
                    return lhsNode.id == rhsNode.id
                case let (.expression(lhsNode), .expression(rhsNode)):
                    return lhsNode.id == rhsNode.id
                default:
                    return false
                }
            }

            // MARK: - Internal Init for testing

            init(_ item: CodeBlockItemSyntax.Item) {
                switch item {
                case let .decl(declSyntax):
                    self = .declaration(declSyntax)
                case let .stmt(stmtSyntax):
                    self = .statement(stmtSyntax)
                case let .expr(exprSyntax):
                    self = .expression(exprSyntax)
                }
            }
        }

        /// ``CodeBlock/Statement/Kind`` representation of the underlying `CodeBlockItemSyntax.Item` kind.
        public let kind: Kind

        // MARK: - Properties: DeclarationComponent

        public let node: CodeBlockItemSyntax

        /// Creates a new ``SyntaxSparrow/CodeBlock/Statement`` instance from a `CodeBlockItemSyntax` node.
        public init(node: CodeBlockItemSyntax) {
            self.node = node
            switch node.item {
            case let .decl(declSyntax):
                kind = .declaration(declSyntax)
            case let .stmt(stmtSyntax):
                kind = .statement(stmtSyntax)
            case let .expr(exprSyntax):
                kind = .expression(exprSyntax)
            }
        }
    }
}
