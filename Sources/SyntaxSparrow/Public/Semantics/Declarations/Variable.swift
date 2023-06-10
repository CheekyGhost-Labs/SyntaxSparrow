//
//  Variable.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift variable declaration.
///
/// An instance of the `Variable` struct provides access to various components of the variable declaration it represents, including:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the variable, e.g., `public`.
/// - Keyword: The keyword used for the declaration, i.e., "var" or "let".
/// - Name: The name of the variable.
/// - Type: The type of the variable.
/// - InitializedType: The initial value assigned to the variable at declaration, if any.
/// - Accessors: Any getter and/or setter associated with the variable.
///
/// Each instance of ``SyntaxSparrow/Variable`` corresponds to a `PatternBindingSyntax` node in the Swift syntax tree.
///
/// The `Variable` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the variable
/// declaration is located.
public struct Variable: Declaration, SyntaxSourceLocationResolving {
    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"let"` or `"var"`
    public var keyword: String { resolver.keyword }

    /// The variable name.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// var myName: String = "name"
    /// ```
    /// - The `name` is equal to `myName`
    public var name: String { resolver.name }

    /// The variable name.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// var myName: String
    /// ```
    /// - The `name` is equal to `myName`
    public var type: EntityType { resolver.type }

    /// The initialized type, if any.
    ///
    /// For example, in the following declarations
    /// ```swift
    /// var myName: String
    /// var myName: String = "name"
    /// ```
    /// - The first declaration has an initialized type of `nil`
    /// - The second declaration has an initialized type of `"name"`
    public var initializedType: String? { resolver.initializedValue }

    /// The variable or property accessors.
    public var accessors: [Accessor] { resolver.accessors }

    /// Will return a `Bool` flag indicating if the variable type is marked as optional. `?`
    var isOptional: Bool { resolver.isOptional }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: VariableSemanticsResolver

    // MARK: - Lifecycle

    /// Will create and return an array of variables from the given variable declaration syntax, which can contain one or more pattern bindings.
    ///
    /// For example, `let x: Int = 1, y: Int = 2`.
    /// - Parameters:
    ///   - node: The node to convert.
    ///   - context: The parent source explorer context.
    /// - Returns: Array of ``SyntaxSparrow/Variable`` instance.
    public static func variables(from node: VariableDeclSyntax, context: SyntaxExplorerContext) -> [Variable] {
        node.bindings.compactMap { Variable(node: $0, context: context) }
    }

    /// Creates a new ``SyntaxSparrow/Variable`` instance from an `PatternBindingSyntax` node.
    public init(node: PatternBindingSyntax, context: SyntaxExplorerContext) {
        resolver = VariableSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        // no-op
    }

    // MARK: - Equatable

    public static func == (lhs: Variable, rhs: Variable) -> Bool {
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
