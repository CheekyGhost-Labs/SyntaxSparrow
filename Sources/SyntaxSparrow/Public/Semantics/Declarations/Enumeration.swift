//
//  Enumeration.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift enumeration declaration.
///
/// An enumeration is a common type of data structure that consists of a set of named cases, which are known as its members.
/// In Swift, enumerations are first-class types, and they adopt many features traditionally supported only by classes.
///
/// Each instance of ``SyntaxSparrow/Enumeration`` corresponds to an `EnumDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, and `SyntaxSourceLocationResolving`,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Enumeration: Declaration, SyntaxChildCollecting {

    // MARK: - Properties: Declaration

    public var node: EnumDeclSyntax { resolver.node }

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
    /// i.e: `"enum"`
    public var keyword: String { resolver.keyword }

    /// The structure name.
    ///
    /// i.e: `enum MyEnum { ... }` would have a name of `"MyEnum"`
    /// If the structure is unnamed, this will be an empty string.
    public var name: String { resolver.name }

    /// Array of type names representing the adopted protocols.
    ///
    /// For example, in the following declaration, the inheritance of the struct would be `["String", "A"]`
    /// ```swift
    /// protocol A {}
    /// enum MyEnum: String, A {}
    /// ```
    public var inheritance: [String] { resolver.inheritance }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// struct MyEnum<T: Equatable>: String {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// enum MyEnum<T>: String where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    /// Array of cases declared within the enumeration.
    ///
    /// For example, ind the following declaration there are two cases named `optionOne` and `optionTwo`
    /// ```swift
    /// enum MyEnum {
    ///     case optionOne
    ///     case optionTwo
    /// }
    /// ```
    public var cases: [Enumeration.Case] { resolver.cases }

    // MARK: - Properties: Resolving

    private(set) var resolver: EnumerationSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = DeclarationCollection()

    // MARK: - Lifecycle

    public init(node: EnumDeclSyntax) {
        resolver = EnumerationSemanticsResolver(node: node)
    }
}
