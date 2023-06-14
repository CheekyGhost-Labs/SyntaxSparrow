//
//  GenericParameter.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Class representing a `GenericParameter` from a declaration.
///
/// A generic type or function declaration includes a `generic parameter clause` which is composed of one or more parameters enclosed
/// by angle brackets: `<>`. Each generic parameter has a name, but may also specify a type constraint.
/// For example, the following declaration has two generic parameters:
/// ```swift
/// struct MyStruct<T, U: Equatable>
/// ```
/// - The first parameter is named `"T"` with a `nil` type.
/// - The second parameter is named `"U"` with a type constraint of `"Equatable"`
public struct GenericParameter: DeclarationComponent {
    // MARK: - Properties: DeclarationComponent

    public var node: GenericParameterSyntax { resolver.node }

    // MARK: - Properties

    /// The generic parameter attributes.
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// The generic parameter name.
    public var name: String { resolver.resolveName() }

    /// The generic parameter type, if any.
    public var type: String? { resolver.resolveType() }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: GenericParameterSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/GenericParameter`` instance from an `GenericParameterSyntax` node.
    public init(node: GenericParameterSyntax) {
        resolver = GenericParameterSemanticsResolver(node: node)
    }

    /// Creates an array of ``SyntaxSparrow/GenericParameter`` instances from a `GenericParameterListSyntax` node.
    public static func fromParameterList(from node: GenericParameterListSyntax?) -> [GenericParameter] {
        guard let node = node else { return [] }
        return node.compactMap { GenericParameter(node: $0) }
    }
}
