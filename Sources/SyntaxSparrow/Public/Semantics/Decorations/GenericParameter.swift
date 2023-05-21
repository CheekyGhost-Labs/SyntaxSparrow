//
//  File.swift
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
public class GenericParameter: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {

    // MARK: - Properties - Public

    /// The generic parameter attributes.
    public var attributes: [Attribute] { resolver.attributes }

    /// The generic parameter name.
    public var name: String { resolver.name }

    /// The generic parameter type, if any.
    public var type: String? { resolver.type }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: GenericParameterSemanticsResolver

    // MARK: - Lifecycle

    public init(node: GenericParameterSyntax) {
        self.resolver = GenericParameterSemanticsResolver(node: node)
    }

    public static func fromParameterList(from node: GenericParameterListSyntax?) -> [GenericParameter] {
        guard let node = node else { return [] }
        return node.compactMap { GenericParameter(node: $0) }
    }

    // MARK: - Equatable

    public static func == (lhs: GenericParameter, rhs: GenericParameter) -> Bool {
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

    // MARK: - CustomDebugStringConvertible

    public var debugDescription: String {
        resolver.node.debugDescription.trimmed
    }
}
