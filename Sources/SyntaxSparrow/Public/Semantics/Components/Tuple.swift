//
//  Tuple.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift tuple.
///
/// A tuple in Swift is a compound value that groups multiple values together. The ``SyntaxSparrow/Tuple`` struct provides a representation of a tuple
/// within a Swift source file.
/// Each element in the tuple is represented as a `Parameter` instance.
///
/// This struct provides access to:
/// - The elements of the tuple
/// - Whether the tuple is optional
///
/// The ``SyntaxSparrow/Tuple`` struct provides functionality to create a ``SyntaxSparrow/Tuple`` instance from either
/// a `TupleTypeSyntax` node or a `TupleTypeElementListSyntax` node.
public struct Tuple: Hashable, Equatable, CustomStringConvertible {
    // MARK: - Properties: TupleType

    public var elements: [Parameter] { resolver.resolveElements() }

    public var isOptional: Bool { resolver.resolveIsOptional() }

    private(set) var resolver: any TupleNodeSemanticsResolving

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Tuple`` instance from an `TupleTypeSyntax` node.
    public init(node: TupleTypeSyntax) {
        resolver = TupleSemanticsResolver(node: node)
    }

    /// Creates a new ``SyntaxSparrow/Tuple`` instance from an `TupleTypeElementListSyntax` node.
    public init(node: TupleTypeElementListSyntax) {
        resolver = TupleElementListSemanticsResolver(node: node)
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
