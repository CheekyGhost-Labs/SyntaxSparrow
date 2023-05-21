//
//  Structure.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Extension` is a struct representing a Swift structure declaration. This class is part of the SyntaxSparrow library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Extension` corresponds to a `ExtensionDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging. It also supports the `DeclarationCollecting` protocol to facilitate the collection of child declarations.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties, and further child declarations are collected into
/// named arrays in conformance with the `DeclarationCollecting` protocol.
public struct Extension: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {

    // MARK: - Properties: StructureDeclaration

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"extension"`
    public var keyword: String { resolver.keyword }

    /// The type the declaration is extending.
    ///
    /// i.e: `extension String { ... }` would have an extendedType of `"String"`
    /// If the structure is unnamed, this will be an empty string.
    public var extendedType: String { resolver.extendedType }

    /// Array of type names representing the adopted protocols.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["A", "B"]`
    /// ```swift
    /// protocol A {}
    /// protocol B {}
    /// extension String: A, B {}
    /// ```
    public var inheritance: [String] { resolver.inheritance }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"Element"` whose requirement is a `"String"`
    /// ```swift
    /// extension Collection where Element: String {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: ExtensionSemanticsResolver

    var declarationCollection: DeclarationCollection { resolver.declarationCollection }

    // MARK: - Lifecycle

    public init(node: ExtensionDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = ExtensionSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        resolver.collectChildren()
    }

    // MARK: - Equatable

    public static func == (lhs: Extension, rhs: Extension) -> Bool {
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

extension Extension: DeclarationCollecting {}
