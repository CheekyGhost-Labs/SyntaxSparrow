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
/// Each instance of ``SyntaxSparrow/AssociatedType`` corresponds to a `AssociatedTypeDeclSyntax` node in the Swift syntax tree.
///
/// The `AssociatedType` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the associated
/// type declaration is located.
public struct AssociatedType: Declaration {
    // MARK: - Properties: Declaration

    public var node: AssociatedTypeDeclSyntax { resolver.node }

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
    /// i.e: `"associatedtype"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The structure name.
    ///
    /// i.e: `struct MyClass { ... }` would have a name of `"MyClass"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.resolveName() }

    /// Array of type names representing the types the class inherits.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["B", "A"]`
    /// ```swift
    /// protocol A {}
    /// class B {}
    /// class MyClass: B, A {}
    /// ```
    public var inheritance: [String] { resolver.resolveInheritance() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// struct MyClass<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: AssociatedTypeSemanticsResolver

    // MARK: - Lifecycle

    public init(node: AssociatedTypeDeclSyntax) {
        resolver = AssociatedTypeSemanticsResolver(node: node)
    }
}
