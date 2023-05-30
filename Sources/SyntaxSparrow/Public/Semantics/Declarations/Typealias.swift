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
/// Each instance of ``SyntaxSparrow/Typealias`` corresponds to a `TypealiasDeclSyntax` node in the Swift syntax tree.
///
/// The `Typealias` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the typealias declaration is located.
public struct Typealias: Declaration, SyntaxSourceLocationResolving {

    // MARK: - Properties: Computed

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"class"`
    public var keyword: String { resolver.keyword }

    /// The structure name.
    ///
    /// i.e: `struct MyClass { ... }` would have a name of `"MyClass"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.name }

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
    public var initializedType: EntityType { resolver.initializedType }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// typealias EquatableArray<T: Equatable> = Array<T>
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Equatable"`
    /// ```swift
    /// typealias EquatableArray<T> where T: Equatable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: TypealiasSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Typealias`` instance from an `TypealiasDeclSyntax` node.
    public init(node: TypealiasDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = TypealiasSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: Typealias, rhs: Typealias) -> Bool {
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
