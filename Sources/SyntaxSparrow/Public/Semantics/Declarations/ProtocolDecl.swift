//
//  Protocol.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift protocol declaration.
///
/// An instance of the `ProtocolDecl` struct provides access to various components of the protocol declaration it represents, including:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the protocol, e.g., `public`.
/// - Name: The name of the protocol.
/// - AssociatedTypes: Any associated types declared within the protocol, along with their requirements and constraints.
/// - PrimaryAssociatedTypes: The primary associated types of the protocol, these are declared in the declaration's angle brackets.
/// - Inheritance: Any types that the protocol inherits from, including other protocols.
/// - GenericRequirements: Information about any generic requirements applied to the protocol.
///
/// Each instance of ``SyntaxSparrow/Protocol`` corresponds to a `ProtocolDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, and `SyntaxSourceLocationResolving`,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct ProtocolDecl: Declaration, SyntaxSourceLocationResolving {
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

    /// The primary associated types for the declaration.
    ///
    /// For example, the following declaration of `MyProtocol` has three associated types:
    /// ```swift
    /// protocol MyProtocol {
    ///   associatedType Parameter
    ///   associatedType Object: Equatable
    ///   associatedType Node: AnyObject where Node: Hashable
    /// }
    /// ```
    /// - The first type is `"Parameter"` with no inheritand or requirements
    /// - The second type is `"Object"` which needs to inherit `["Equatable"]`
    /// - The third  type is `"Node"` which needs to be a class type (`["AnyObject"]`) and the inferred `"Node"` type is required to conform to
    /// `Hashable`
    public var associatedTypes: [AssociatedType] { resolver.associatedTypes }

    /// The primary associated types for the declaration.
    ///
    /// For example, the following declaration of `MyProtocol` has two primary associated types:
    /// ```swift
    /// protocol MyProtocol<Parameter, Object> {}
    /// ```
    /// - The first type is `"Parameter"`
    /// - The first type is `"Object"`
    public var primaryAssociatedTypes: [String] { resolver.primaryAssociatedTypes }

    /// Array of type names representing the types the class inherits.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["B", "A"]`
    /// ```swift
    /// protocol A {}
    /// class B {}
    /// class MyClass: B, A {}
    /// ```
    public var inheritance: [String] { resolver.inheritance }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// struct MyClass<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: ProtocolSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Protocol`` instance from an `ProtocolDeclSyntax` node.
    public init(node: ProtocolDeclSyntax, context: SyntaxExplorerContext) {
        resolver = ProtocolSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: ProtocolDecl, rhs: ProtocolDecl) -> Bool {
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
