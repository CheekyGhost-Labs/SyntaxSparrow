//
//  Actor.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a class declaration in Swift source code.
///
/// A `Actor` struct provides access to various aspects of the class declaration it represents, such as:
/// - Attributes: Any attributes associated with the class declaration, e.g. `@available`.
/// - Modifiers: Modifiers applied to the class, e.g. `public`, `final`.
/// - Name: The name of the actor.
/// - Inheritance: Types that the class inherits from (if any), including both classes and protocols.
/// - Generic parameters and requirements: Information about any generic parameters or requirements that the class has.
///
/// Each instance of ``SyntaxSparrow/Actor`` corresponds to a `ActorDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Actor: Declaration, SyntaxChildCollecting {

    // MARK: - Properties: Declaration

    public var node: ActorDeclSyntax { resolver.node }

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
    /// i.e: `"actor"`
    public var keyword: String { resolver.keyword }

    /// The actor name.
    ///
    /// i.e: `actor MyActor { ... }` would have a name of `"MyActor"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.name }

    /// Array of type names representing the types the actor inherits.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["A", "B"]`
    /// ```swift
    /// protocol A {}
    /// protocol B {}
    /// actor MyActor: A, B {}
    /// ```
    public var inheritance: [String] { resolver.inheritance }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// actor MyActor<T: Equatable> {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// actor MyActor<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    // MARK: - Properties: Resolving

    private(set) var resolver: ActorSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = DeclarationCollection()

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Class`` instance from an `ClassDeclSyntax` node.
    public init(node: ActorDeclSyntax) {
        resolver = ActorSemanticsResolver(node: node)
    }
}
