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
                case (.declaration(let lhsNode), .declaration(let rhsNode)):
                    return lhsNode.id == rhsNode.id
                case (.statement(let lhsNode), .statement(let rhsNode)):
                    return lhsNode.id == rhsNode.id
                case (.expression(let lhsNode), .expression(let rhsNode)):
                    return lhsNode.id == rhsNode.id
                default:
                    return false
                }
            }

            // MARK: - Internal Init for testing

            init(_ item: CodeBlockItemSyntax.Item) {
                switch item {
                case .decl(let declSyntax):
                    self = .declaration(declSyntax)
                case .stmt(let stmtSyntax):
                    self = .statement(stmtSyntax)
                case .expr(let exprSyntax):
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
            case .decl(let declSyntax):
                kind = .declaration(declSyntax)
            case .stmt(let stmtSyntax):
                kind = .statement(stmtSyntax)
            case .expr(let exprSyntax):
                kind = .expression(exprSyntax)
            }
        }
    }
}
