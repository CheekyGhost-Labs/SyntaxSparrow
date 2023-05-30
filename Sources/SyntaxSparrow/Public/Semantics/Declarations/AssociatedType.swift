//
//  AssociatedType.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents an associated type declaration within a Swift protocol declaration.
///
/// An `AssociatedType` provides access to various aspects of the associated type declaration it represents, such as:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the associated type, e.g., `public`.
/// - Name: The name of the associated type.
/// - Inheritance: Any types the associated type is constrained to, including both classes and protocols.
/// - Generic requirements: Information about any generic requirements applied to the associated type.
///
/// Each instance of ``SyntaxSparrow/AssociatedType`` corresponds to a `AssociatedtypeDeclSyntax` node in the Swift syntax tree.
///
/// The `AssociatedType` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the associated type declaration is located.
public struct AssociatedType: Declaration, SyntaxSourceLocationResolving {

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

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: AssociatedTypeSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/AssociatedType`` instance from an `AssociatedtypeDeclSyntax` node.
    public init(node: AssociatedtypeDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = AssociatedTypeSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: AssociatedType, rhs: AssociatedType) -> Bool {
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
