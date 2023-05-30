//
//  Typealias.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Typealias` is a class representing a Swift protocol declaration. This class is part of the `SyntaxSparrow` library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a protocol declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Typealias` corresponds to a `TypealiasDeclSyntax` node in the Swift syntax tree.
///
/// `Protocol` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging. It does not support the `DeclarationCollecting` as Swift iteslf does not support declaring types within a protocol.
///
/// The location of the protocol in the source code is captured in `startLocation` and `endLocation` properties.
public class Typealias: Declaration, SyntaxSourceLocationResolving {

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
