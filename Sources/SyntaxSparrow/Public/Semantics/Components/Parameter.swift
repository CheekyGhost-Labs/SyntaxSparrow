//
//  Parameter.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift function or method parameter.
///
/// A parameter is a variable in a method or function definition that accepts input from the caller of the method or function. In Swift, function
/// parameters can have a
/// variety of attributes, including labels, types, default values, and special attributes like `inout`.
///
/// An instance of the `Parameter` struct provides access to:
/// - The parameter's attributes, name(s), type, and raw type.
/// - Whether the parameter accepts a variadic argument or is optional.
/// - Whether the parameter is marked with `inout` or its label is omitted.
/// - The default argument of the parameter, if any.
///
/// A parameter has common properties, and then a ``SyntaxSparrow/EntityType`` property which further describes the input by including associated
/// properties as needed.
/// For example, a parameter with the type`.closure` will have a `Closure` provided, where as a parameter with the `.tuple` type will have a
/// ``SyntaxSparrow/Tuple`` associated properties.
///
/// This struct also includes functionality to create a `Parameter` instance from either a `FunctionParameterSyntax` node or a
/// `TupleTypeElementSyntax` node.
public struct Parameter: Equatable, Hashable, CustomStringConvertible {
    // MARK: - Properties: DeclarationComponent

    /// The node being represented by the ``Parameter`` instance.
    /// **Note:** The node type will be one of the types supported by the `Paramater.init` methods.
    /// You can use the `as(SyntaxProtocol.Protocol)` cast method to resolve the expected one.
    /// For example:
    /// ```swift
    /// let node = parameter.node // The parameter node
    /// node.as(FunctionParameterSyntax.self) // Casts to function parameter syntax node or returns `nil`
    /// node.as(TupleTypeElementSyntax.self) // Casts to tuple element parameter syntax node or returns `nil`
    /// node.as(EnumCaseParameterSyntax.self) // Casts to an enum associated value parameter syntax node or returns `nil`
    /// ```
    public var node: Syntax { resolver.node._syntaxNode }

    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The first, external name of the parameter.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func increment(_ number: Int, by amount: Int)
    /// ```
    /// - The first parameter has a `name` equal to `"_"`
    /// - The second parameter has a `name` equal to `"by"`
    public var name: String? { resolver.resolveName() }

    /// The second internal name of the parameter.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func increment(_ number: Int, by amount: Int)
    /// ```
    /// - The first parameter has a `secondName` equal to `"number"`
    /// - The second parameter has a `secondName` equal to `"amount"`
    public var secondName: String? { resolver.resolveSecondName() }

    /// The `EntityType` resolve from the parameter
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func greet(_ person: Person, with phrases: String, dimensions: (height: Double, weight: Double))
    /// ```
    /// - The first parameter type will be `.simple("Person")`
    /// - The second parameter type will be `.simple("String")`
    /// - The third parameter type will be `.dimensions(Tuple)` where the associated tuple has parameters with types `.simple("Double")` and
    /// `.simple("Double")`
    /// - See: ``SyntaxSparrow/EntityType``
    public var type: EntityType { resolver.resolveType() }

    /// The raw type string.
    public var rawType: String? { resolver.resolveRawType() }

    /// Bool whether the parameter accepts a variadic argument.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func greet(_ person: Person, with phrases: String...)
    /// ```
    /// - The second parameter is variadic
    public var isVariadic: Bool { resolver.resolveIsVariadic() }

    /// Will return a `Bool` flag indicating if the closure declaration is marked as optional. `?`
    public var isOptional: Bool { resolver.resolveIsOptional() }

    /// The default argument of the parameter (if any).
    ///
    /// For example, given the following declaration:
    /// ```swift
    /// func processCount(_ number: Int, by amount: Int = 1)
    /// ```
    /// - The second parameter has a default argument equal to `"1"`.
    public var defaultArgument: String? { resolver.resolveDefaultArgument() }

    /// Bool whether the parameter is marked with `inout`
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func processForm(_ form: inout Form)
    /// ```
    /// - The parameter is inout
    public var isInOut: Bool { resolver.resolveIsInOut() }

    /// Bool whether the parameter name is marked as no label `_`.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func processResult(_ result: Result<String, Error>)
    /// ```
    /// - The parameter has the label ommitted.
    ///
    /// **Note:** This will be `false` for completely label-less types. For example:
    /// ```swift
    /// typealias Person = (String, Int)
    /// ```
    /// - Both parameter arguments in the tuple will have `isLabelOmitted` as `false`
    public var isLabelOmitted: Bool { name == "_" }

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

    // MARK: - Properties: Resolving

    private(set) var resolver: any ParameterNodeSemanticsResolving

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Parameter`` instance from an `FunctionParameterSyntax` node.
    public init(node: FunctionParameterSyntax) {
        resolver = FunctionParameterSemanticsResolver(node: node)
    }

    /// Creates a new ``SyntaxSparrow/Parameter`` instance from an `TupleTypeElementSyntax` node.
    public init(node: TupleTypeElementSyntax) {
        resolver = TupleParameterSemanticsResolver(node: node)
    }

    /// Creates a new ``SyntaxSparrow/Parameter`` instance from an `TupleTypeElementSyntax` node.
    public init(node: EnumCaseParameterSyntax) {
        resolver = EnumCaseParameterSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: Parameter, rhs: Parameter) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        resolver.resolveDescription()
    }
}
