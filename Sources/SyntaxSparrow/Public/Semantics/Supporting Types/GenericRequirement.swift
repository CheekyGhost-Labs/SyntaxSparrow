//
//  GenericRequirement.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Class representing a generic requirement on a declaration.
///
/// A generic type ofr function can specify one or more requirements as part of a `generic where clause` before the opening curly brace `{` of it's body.
/// Each generic requirement establishes a relation between two type identifiers.
///
/// For example, in the following declaration, two generic requirements are defined:
/// ```swift
/// func difference<C1: Collection, C3: Collection>(between lhs: C1, and rhs: C2) -> [C1.Element]
///     where C1.Element: Equatable, C1.Element == C2.Element { ... }
/// ```
/// - The first requirement defines a `conformance` relation between the types identified in `C1.Element` and `Equatable`
/// - The first requirement defines a `sameType` relation between the types identified in `C1.Element` and `C2.Element`
///
/// A requirement may also be a `layout` relation, which specifies a constraint on the memory layout of an associated type.
/// For example, the following declaration defines a `layout` relation
/// ```swift
/// protocol P where Self: AnyObject {...}
/// ```
/// - The layout relation defines an `AnyObject` constraint: Specifying that an associated type must be a class type.
/// **Note:** All `layout` relation requirements will have a `leftTypeIdentifier` of `Self`. While not explicitly defined in the requirement itself, it is a
/// pre-requisite for the declaration.
public class GenericRequirement: Equatable, Hashable, CustomStringConvertible, CustomDebugStringConvertible {

    /**
     A relation between the two types identified
     in the generic requirement.

     For example,
     the declaration `struct S<T: Equatable>`
     has a single generic requirement
     that the type identified by `"T"`
     conforms to the type identified by `"Equatable"`.
     */
    public enum Relation: String, Hashable, Codable {
        /**
         The type identified on the left-hand side is equivalent to
         the type identified on the right-hand side of the generic requirement.
         */
        case sameType

        /**
         The type identified on the left-hand side conforms to
         the type identified on the right-hand side of the generic requirement.
        */
        case conformance

        /// A layout requirement specifies a constraint on the memory layout of an associated type.
        /// i.e It could specify that the associated type must be a class (reference type), or that it must be a type that doesn't have a known size at compile time (e.g., an existential type).
        /// For example:
        /// ```swift
        /// protocol P where Self: AnyObject {...}
        /// ```
        /// - AnyObject constraint: Specifies that an associated type must be a class type.
        case layout
    }

    /// The relation between the two identified types.
    public var relation: Relation { resolver.relation }

    /// The identifier for the left-hand side type.
    /// **Note:** When the relation is `.layout` the value will always be `Self`. While this is accurate, it is worth noting that it is not directly declared in he requirement
    public var leftTypeIdentifier: String { resolver.leftTypeIdentifier }

    /// The identifier for the right-hand side type.
    public var rightTypeIdentifier: String { resolver.rightTypeIdentifier }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: GenericRequirementSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/GenericRequirement`` instance from an `GenericRequirementSyntax` node.
    public init(_ node: GenericRequirementSyntax) {
        self.resolver = GenericRequirementSemanticsResolver(node: node)
    }

    /**
     Creates and returns generic requirements initialized from a
     generic requirement list syntax node.

     - Parameter from: The generic requirement list syntax node, or `nil`.
     - Returns: An array of generic requirements, or `nil` if the node is `nil`.
     */
    public static func fromRequirementList(from node: GenericRequirementListSyntax?) -> [GenericRequirement] {
        guard let node = node else { return [] }
        return node.compactMap { GenericRequirement($0) }
    }

    // MARK: - Equatable

    public static func == (lhs: GenericRequirement, rhs: GenericRequirement) -> Bool {
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
