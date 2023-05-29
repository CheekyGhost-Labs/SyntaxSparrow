//
//  Enumeration.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax


public class Enumeration: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {

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

    // TODO: Cases

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: EnumerationSemanticsResolver

    var declarationCollection: DeclarationCollection { resolver.declarationCollection }

    // MARK: - Lifecycle

    public init(node: EnumDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = EnumerationSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        resolver.collectChildren()
    }

    // MARK: - Equatable

    public static func == (lhs: Enumeration, rhs: Enumeration) -> Bool {
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

extension Enumeration: DeclarationCollecting {}
