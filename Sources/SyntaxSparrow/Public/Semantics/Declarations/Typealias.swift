//
//  Typealias.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift typealias declaration.
///
/// An instance of the `Typealias` struct provides access to various components of the typealias declaration it represents, including:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the typealias, e.g., `public`.
/// - Keyword: The keyword used for the declaration, i.e., "typealias".
/// - Name: The name of the typealias.
/// - InitializedType: The type the typealias is set to represent.
/// - GenericParameters: Any generic parameters used in the typealias definition, along with their constraints.
/// - GenericRequirements: Information about any generic requirements applied to the typealias.
///
/// Each instance of ``SyntaxSparrow/Typealias`` corresponds to a `TypeAliasDeclSyntax` node in the Swift syntax tree.
///
/// The `Typealias` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the typealias
/// declaration is located.
public struct Typealias: Declaration {
    // MARK: - Properties: Declaration

    public var node: TypeAliasDeclSyntax { resolver.node }

    // MARK: - Properties: Computed

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"class"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The structure name.
    ///
    /// i.e: `struct MyClass { ... }` would have a name of `"MyClass"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.resolveName() }

    /// The initialized type, if any.
    ///
    /// For example, in the following declarations
    /// ```swift
    /// typealias Sample = Int
    /// typealias OtherSample
    /// typealias CustomThing = (name: String, age: Int)
    /// ```
    /// - The first declaration has an initialized type of `.simple("Int")`
    /// - The second declaration has an initialized type of `.empty` as it is only partially defined
    /// - The third declaration has no initialized type of `.tuple(Tuple)`
    public var initializedType: EntityType { resolver.resolveInitializedType() }

    /// Bool indicating whether the resolved `initializedType` property is optional.
    ///
    /// For example:
    /// ```swift
    /// typealias StringAlias = String?
    /// typealias IntAlias = Int
    /// ```
    /// - The `StringAlias` `initializedType` is `.simple("String?")` and `initializedTypeIsOptional` is `true`
    /// - The `IntAlias` `initializedType` is `.simple("Int")` and `initializedTypeIsOptional` is `false`
    public var initializedTypeIsOptional: Bool { resolver.resolveInitializedTypeIsOptional() }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// typealias EquatableArray<T: Equatable> = Array<T>
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Equatable"`
    /// ```swift
    /// typealias EquatableArray<T> where T: Equatable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: TypealiasSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Typealias`` instance from an `TypeAliasDeclSyntax` node.
    public init(node: TypeAliasDeclSyntax) {
        resolver = TypealiasSemanticsResolver(node: node)
    }
}
