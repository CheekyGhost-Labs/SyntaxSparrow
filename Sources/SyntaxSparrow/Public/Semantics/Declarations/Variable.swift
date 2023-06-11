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
public struct Variable: Declaration {

    // MARK: - Properties: Declaration

    public var node: PatternBindingSyntax { resolver.node }
    
    /// Returns the first `VariableDeclSyntax` node in sequence from the `node` property.
    ///
    /// This is provided as the `VariableDeclSyntax` contains one or more `PatternBindingSyntax` syntaxes that represent
    /// the variable. The `VariableDeclSyntax` is a container.
    ///
    /// For example, you may declare multiple variables on the same line:
    /// ```swift
    /// var firstName: String, secondName: String
    /// ```
    public var parentDeclarationSyntax: VariableDeclSyntax? {
        node.firstParent(returning: { $0.as(VariableDeclSyntax.self) })?.as(VariableDeclSyntax.self)
    }

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
    public var initializedValue: String? { resolver.initializedValue }

    /// The variable or property accessors.
    public var accessors: [Accessor] { resolver.accessors }

    /// Will return a `Bool` flag indicating if the variable type is marked as optional. `?`
    var isOptional: Bool { resolver.isOptional }
    
    /// Bool whether the `accessors` contains the `set` kind, or the `keyword` is `"var"` and the variable is not within a protocol declaration.
    public var hasSetter: Bool { resolver.hasSetter }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: VariableSemanticsResolver

    // TODO: Enable child collection within get/set blocks (may need to expose the get/set blocks too)?

    // MARK: - Lifecycle

    /// Will create and return an array of variables from the given variable declaration syntax, which can contain one or more pattern bindings.
    ///
    /// For example, `let x: Int = 1, y: Int = 2`.
    /// - Parameters:
    ///   - node: The node to convert.
    ///   - context: The parent source explorer context.
    /// - Returns: Array of ``SyntaxSparrow/Variable`` instance.
    public static func variables(from node: VariableDeclSyntax) -> [Variable] {
        node.bindings.compactMap { Variable(node: $0) }
    }

    public init(node: PatternBindingSyntax) {
        resolver = VariableSemanticsResolver(node: node)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        let targetNode = node.context?._syntaxNode ?? node._syntaxNode
        return targetNode.description.trimmed
    }
}
