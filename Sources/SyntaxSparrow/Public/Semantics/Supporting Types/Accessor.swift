//
//  Accessor.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift accessor declaration.
///
/// An accessor is a special kind of method that gets, sets, or computes the value of a variable. In Swift, they are typically found within property and subscript declarations.
///
/// An instance of the `Accessor` struct provides access to:
/// - The kind of accessor, which can be `get` or `set`.
/// - Attributes associated with the accessor declaration, e.g., `@available`.
/// - Modifier applied to the accessor, e.g., `private`.
///
/// The `Accessor` struct also includes functionality to create an accessor instance from an `AccessorDeclSyntax` node.
public struct Accessor: Equatable, Hashable, CustomStringConvertible {

    /// The kind of accessor (`get` or `set`).
    public enum Kind: String, Hashable, Codable {
        /// A getter that returns a value.
        case get

        /// A setter that sets a value.
        case set
    }

    /// The accessor attributes.
    public let attributes: [Attribute]

    /// The accessor modifiers.
    public let modifier: Modifier?

    /// The kind of accessor.
    public let kind: Kind?

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Accessor`` instance from an `AccessorDeclSyntax` node.
    public init(_ node: AccessorDeclSyntax) {
        // Attributes
        attributes = Attribute.fromAttributeList(node.attributes)
        // Modifier
        if let modifierNode = node.modifier {
            modifier = Modifier(modifierNode)
        } else {
            modifier = nil
        }
        // Kind
        let rawKind = node.accessorKind.text.trimmed
        kind = Kind(rawValue: rawKind)
        // Description
        description = node.description.trimmed
    }

    // MARK: - Equatable

    public static func == (lhs: Accessor, rhs: Accessor) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - CustomStringConvertible

    public let description: String

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }
}
