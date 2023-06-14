//
//  File.swift
//  
//
//  Created by Michael O'Brien on 13/6/2023.
//

import Foundation
import SwiftSyntax

/// Represents the swift code block element `CodeBlockSyntax`.
///
/// A code block is primarily a list of code statements within parenthesis `{` and `}`. For example, the `get/set/willSet/didSet` accessors in a variable, a function body etc.
///
/// An instance of the `CodeBlock` struct provides access to an array of statements held within.
public struct CodeBlock: DeclarationComponent {

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

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/CodeBlock`` instance from a `CodeBlockSyntax` node.
    public init(node: CodeBlockSyntax) {
        self.node = node
        statements = node.statements.map { Statement(node: $0) }
    }
}
