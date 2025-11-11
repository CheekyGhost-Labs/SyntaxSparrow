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
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"let"` or `"var"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The variable name.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// var myName: String = "name"
    /// ```
    /// - The `name` is equal to `myName`
    public var name: String { resolver.resolveName() }

    /// The variable name.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// var myName: String
    /// ```
    /// - The `name` is equal to `myName`
    public var type: EntityType { resolver.resolveType() }

    /// The initialized type, if any.
    ///
    /// For example, in the following declarations
    /// ```swift
    /// var myName: String
    /// var myName: String = "name"
    /// ```
    /// - The first declaration has an initialized type of `nil`
    /// - The second declaration has an initialized type of `"name"`
    public var initializedValue: String? { resolver.resolveInitializedValue() }

    /// The variable or property accessors.
    public var accessors: [Accessor] { resolver.resolveAccessors() }

    /// Will return a `Bool` flag indicating if the variable type is marked as optional. `?`
    public var isOptional: Bool { resolver.resolveIsOptional() }

    /// Bool whether the `accessors` contains the `set` kind, or the `keyword` is `"var"` and the variable is not within a protocol declaration.
    public var hasSetter: Bool { resolver.resolveHasSetter() }
    
    /// Returns true when the variable is a computed property.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// var name: String {
    ///     "testing"
    /// }
    /// var name: String {
    ///     let count = 5
    ///     return "testing: \(count)"
    /// }
    /// ```
    public var isComputed: Bool { resolver.resolveIsComputed() }
    
    /// Returns true when the variable is not a computed property.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// var name: String {
    ///     get { "name" }
    ///     set {}
    /// }
    /// var name: String {
    ///     willSet { }
    /// }
    /// var name: String = "name"
    /// let name: String = "name"
    /// private(set) var name: String = "name"
    /// var name: String {
    ///     get {
    ///         let count = 5
    ///         return "testing: \(count)"
    ///     }
    /// }
    /// ```
    public var isStored: Bool { !isComputed }

    /// Returns `true` when there is a getter accessor that has the `throw` keyword.
    ///
    /// **Note:** Assesses the ``Accessor/effectSpecifiers`` property of the getter accessor  within the``Variable/accessors`` array.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// var name: String {
    ///     get throws {
    ///         "name"
    ///     }
    /// }
    /// ```
    public var isThrowing: Bool {
        return accessors.contains(where: { $0.kind == .get && $0.effectSpecifiers?.throwsSpecifier != nil })
    }

    /// Returns `true` when there is a getter accessor that has the `async` keyword.
    /// 
    /// **Note:** Assesses the ``Accessor/effectSpecifiers`` property of the getter accessor within the``Variable/accessors`` array.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// var name: String {
    ///     get async {
    ///         "name"
    ///     }
    /// }
    /// ```
    public var isAsync: Bool {
        return accessors.contains(where: { $0.kind == .get && $0.effectSpecifiers?.asyncSpecifier != nil })
    }

    /// A Boolean value indicating whether the variable's type is an existential type (prefixed with `any`).
    ///
    /// Existential types allow for runtime polymorphism by type-erasing the concrete implementation
    /// behind a protocol constraint. This property returns `true` when the variable is declared with
    /// the `any` keyword.
    ///
    /// For example:
    /// ```swift
    /// var handler: any Sendable  // isExistential = true
    /// var items: [any Codable]   // isExistential = false (the variable is an array, but contains existential elements)
    /// var name: String           // isExistential = false
    /// ```
    ///
    /// **Note:** This property only checks if the top-level type is existential. For nested existential
    /// types (such as array elements), you need to inspect the ``type`` property directly.
    public var isExistential: Bool {
        type.isExistential
    }

    /// A Boolean value indicating whether the variable's type is an opaque type (prefixed with `some`).
    ///
    /// Opaque types provide compile-time polymorphism by hiding the concrete type behind a protocol
    /// constraint while preserving type identity. This property returns `true` when the variable is
    /// declared with the `some` keyword.
    ///
    /// For example:
    /// ```swift
    /// var view: some View        // isOpaque = true
    /// var items: [some Sendable] // isOpaque = false (the variable is an array, but contains opaque elements)
    /// var name: String           // isOpaque = false
    /// ```
    ///
    /// **Note:** This property only checks if the top-level type is opaque. For nested opaque types
    /// (such as array elements), you need to inspect the ``type`` property directly.
    public var isOpaque: Bool {
        type.isOpaque
    }

    /// Returns the existential or opaque type keyword used in the variable's type declaration, if present.
    ///
    /// This property returns `"any"` for existential types, `"some"` for opaque types, or `nil` if the
    /// variable's type is neither existential nor opaque.
    ///
    /// For example:
    /// ```swift
    /// var handler: any Sendable     // someOrAnyKeyword = "any"
    /// var view: some View           // someOrAnyKeyword = "some"
    /// var name: String              // someOrAnyKeyword = nil
    /// var items: [any Codable]      // someOrAnyKeyword = nil (top-level type is array)
    /// ```
    ///
    /// **Note:** This property only checks the top-level type. For nested existential or opaque types
    /// (such as `[any Codable]` or `(some View) -> Void`), this returns `nil` because the variable's
    /// direct type is the collection or closure, not the existential/opaque type itself.
    ///
    /// - Returns: `"any"` if the type is existential, `"some"` if the type is opaque, or `nil` otherwise.
    public var someOrAnyKeyword: String? {
        if isExistential {
            return "any"
        } else if isOpaque {
            return "some"
        } else {
            return nil
        }
    }

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
