//
//  Structure.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift struct declaration.
///
/// An instance of the `Structure` struct provides access to various components of the struct declaration it represents, including:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the struct, e.g., `public`.
/// - Keyword: The keyword used for the declaration, i.e., "struct".
/// - Name: The name of the struct.
/// - Inheritance: Any protocols that the struct conforms to.
/// - GenericParameters: Any generic parameters used in the struct definition, along with their constraints.
/// - GenericRequirements: Information about any generic requirements applied to the struct.
///
/// Each instance of ``SyntaxSparrow/Structure`` corresponds to a `StructDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Structure: Declaration, SyntaxChildCollecting {
    // MARK: - Properties: Declaration

    public var node: StructDeclSyntax { resolver.node }

    // MARK: - Properties: StructureDeclaration

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"struct"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The structure name.
    ///
    /// i.e: `struct MyStruct { ... }` would have a name of `"MyStruct"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.resolveName() }

    /// Array of type names representing the adopted protocols.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["A", "B"]`
    /// ```swift
    /// protocol A {}
    /// protocol B {}
    /// struct MyStruct: A, B {}
    /// ```
    public var inheritance: [String] { resolver.resolveInheritance() }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// struct MyStruct<T: Equatable> {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// struct MyStruct<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    // MARK: - Properties: Resolving

    private(set) var resolver: StructureSemanticsResolver

    // MARK: - Properties: DeclarationCollecting

    public var childCollection: DeclarationCollection = .init()

    // MARK: - Lifecycle

    public init(node: StructDeclSyntax) {
        resolver = StructureSemanticsResolver(node: node)
    }
}
