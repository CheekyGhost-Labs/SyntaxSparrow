//
//  Accessor.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// A computed variable or computed property accessor.
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

    public init(_ node: AccessorDeclSyntax) {
        // Attributes
        attributes = Attribute.fromAttributeList(node.attributes)
        // Modifier
        if let modifierNode = node.modifier {
            modifier = Modifier(node: modifierNode)
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
