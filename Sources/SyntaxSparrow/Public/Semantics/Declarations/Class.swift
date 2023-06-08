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
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, and `SyntaxSourceLocationResolving`,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Class: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {
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

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// struct MyClass<T: Equatable> {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

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

    private(set) var resolver: ClassSemanticsResolver

    var declarationCollection: DeclarationCollection { resolver.declarationCollection }

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Class`` instance from an `ClassDeclSyntax` node.
    public init(node: ClassDeclSyntax, context: SyntaxExplorerContext) {
        resolver = ClassSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        resolver.collectChildren()
    }

    // MARK: - Equatable

    public static func == (lhs: Class, rhs: Class) -> Bool {
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

extension Class: DeclarationCollecting {}
