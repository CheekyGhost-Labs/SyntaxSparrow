//
//  Structure.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift extension declaration.
///
/// Extensions add new functionality to an existing class, structure, enumeration, or protocol type.
///
/// Each instance of ``SyntaxSparrow/Extension`` corresponds to an `ExtensionDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Extension: Declaration, SyntaxChildCollecting {
    // MARK: - Properties: Declaration

    public var node: ExtensionDeclSyntax { resolver.node }

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
    /// i.e: `"extension"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The type the declaration is extending.
    ///
    /// i.e: `extension String { ... }` would have an extendedType of `"String"`
    /// If the structure is unnamed, this will be an empty string.
    public var extendedType: String { resolver.resolveExtendedType() }

    /// Array of type names representing the adopted protocols.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["A", "B"]`
    /// ```swift
    /// protocol A {}
    /// protocol B {}
    /// extension String: A, B {}
    /// ```
    public var inheritance: [String] { resolver.resolveInheritance() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"Element"` whose requirement is a `"String"`
    /// ```swift
    /// extension Collection where Element: String {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    // MARK: - Properties: Resolving

    private(set) var resolver: ExtensionSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = .init()

    // MARK: - Lifecycle

    public init(node: ExtensionDeclSyntax) {
        resolver = ExtensionSemanticsResolver(node: node)
    }
}
