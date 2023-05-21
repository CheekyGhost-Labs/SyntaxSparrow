//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public struct Tuple: Hashable, Equatable, CustomStringConvertible {

    // MARK: - Properties: TupleType

    public var elements: [Parameter] { resolver.elements }

    public var isOptional: Bool { resolver.isOptional }

    var resolver: any TupleNodeSemanticsResolving

    // MARK: - Lifecycle

    public init(node: TupleTypeSyntax) {
        self.resolver = TupleSemanticsResolver(node: node)
    }

    public init(node: TupleTypeElementListSyntax) {
        self.resolver = TupleElementListSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: Tuple, rhs: Tuple) -> Bool {
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
