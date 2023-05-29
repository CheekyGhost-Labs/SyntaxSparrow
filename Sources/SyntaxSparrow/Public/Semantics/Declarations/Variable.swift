//
//  Variable.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Variable` is a struct representing a Swift structure declaration. This struct is part of the SyntaxSparrow library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Variable` corresponds to a `VariableDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties.
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

    public init(node: PatternBindingSyntax, context: SyntaxExplorerContext) {
        self.resolver = VariableSemanticsResolver(node: node, context: context)
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
