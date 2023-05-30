//
//  Structure.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Structure` is a struct representing a Swift structure declaration. This struct is part of the SyntaxSparrow library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Structure` corresponds to a `StructDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging. It also supports the `DeclarationCollecting` protocol to facilitate the collection of child declarations.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties, and further child declarations are collected into
/// named arrays in conformance with the `DeclarationCollecting` protocol.
public struct Structure: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {

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
    /// i.e: `"struct"`
    public var keyword: String { resolver.keyword }

    /// The structure name.
    ///
    /// i.e: `struct MyStruct { ... }` would have a name of `"MyStruct"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.name }

    /// Array of type names representing the adopted protocols.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["A", "B"]`
    /// ```swift
    /// protocol A {}
    /// protocol B {}
    /// struct MyStruct: A, B {}
    /// ```
    public var inheritance: [String] { resolver.inheritance }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// struct MyStruct<T: Equatable> {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// struct MyStruct<T> where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: StructureSemanticsResolver

    var declarationCollection: DeclarationCollection { resolver.declarationCollection }

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Structure`` instance from an `StructDeclSyntax` node.
    public init(node: StructDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = StructureSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        resolver.collectChildren()
    }

    // MARK: - Equatable

    public static func == (lhs: Structure, rhs: Structure) -> Bool {
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

extension Structure: DeclarationCollecting {}
