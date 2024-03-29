//
//  Class.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a class declaration in Swift source code.
///
/// A `Class` struct provides access to various aspects of the class declaration it represents, such as:
/// - Attributes: Any attributes associated with the class declaration, e.g. `@available`.
/// - Modifiers: Modifiers applied to the class, e.g. `public`, `final`.
/// - Name: The name of the class.
/// - Inheritance: Types that the class inherits from (if any), including both classes and protocols.
/// - Generic parameters and requirements: Information about any generic parameters or requirements that the class has.
///
/// Each instance of ``SyntaxSparrow/Class`` corresponds to a `ClassDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Class: Declaration, SyntaxChildCollecting {
    // MARK: - Properties: Declaration

    public var node: ClassDeclSyntax { resolver.node }

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

    /// The class name.
    ///
    /// i.e: `class MyClass { ... }` would have a name of `"MyClass"`
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

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// struct MyClass<T: Equatable> {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// struct MyClass<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    // MARK: - Properties: Resolving

    private(set) var resolver: ClassSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = .init()

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Class`` instance from an `ClassDeclSyntax` node.
    public init(node: ClassDeclSyntax) {
        resolver = ClassSemanticsResolver(node: node)
    }
}
