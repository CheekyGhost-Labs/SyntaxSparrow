//
//  File.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents the swift code block element `CodeBlockSyntax`.
///
/// A code block is primarily a list of code statements within parenthesis `{` and `}`. For example, the `get/set/willSet/didSet` accessors in a variable, a function body etc.
///
/// An instance of the `CodeBlock` struct provides access to an array of statements held within. It also supports ``SyntaxChildCollecting`` which can collect child declarations.
public struct CodeBlock: DeclarationComponent, SyntaxChildCollecting {
    // MARK: - Supplementary

    /// The kind of accessor (`get` or `set`).
    public enum Kind: String, Hashable, Codable {
        /// A getter that returns a value.
        case get

        /// A setter that sets a value.
        case set
    }

    // MARK: - Properties: DeclarationComponent

    public let node: CodeBlockSyntax

    // MARK: - Properties

    /// Array of statements within the code block.
    public let statements: [Statement]

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = .init()

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/CodeBlock`` instance from a `CodeBlockSyntax` node.
    public init(node: CodeBlockSyntax) {
        self.node = node
        statements = node.statements.map { Statement(node: $0) }
        collectChildren(viewMode: .fixedUp)
    }
}
