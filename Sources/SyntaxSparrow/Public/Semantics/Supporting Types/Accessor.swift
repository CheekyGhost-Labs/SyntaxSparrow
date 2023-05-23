//
//  Accessor.swift
//  
//
//  Created by Michael O'Brien on 23/5/2023.
//

import Foundation
import SwiftSyntax

/// A computed variable or computed property accessor.
public struct Accessor: Hashable {

    /// The kind of accessor (`get` or `set`).
    public enum Kind: String, Hashable, Codable {
        /// A getter that returns a value.
        case get

        /// A setter that sets a value.
        case set
    }

    /// The accessor attributes.
    public let attributes: [Attribute] = []

    /// The accessor modifiers.
    public let modifier: Modifier? = nil

    /// The kind of accessor.
    public let kind: Kind? = nil

    // MARK: - Lifecycle

    public init(_ node: AccessorDeclSyntax) {
        
    }

//    public init?(_ node: AccessorDeclSyntax) {
//        let rawValue = node.accessorKind.text.trimmed
//        if rawValue.isEmpty {
//            self.kind = nil
//        } else if let kind = Kind(rawValue: rawValue) {
//            self.kind = kind
//        } else {
//            return nil
//        }
//
//        attributes = node.attributes?.compactMap{ $0.as(AttributeSyntax.self) }.map { Attribute($0) } ?? []
//        modifier = node.modifier.map { Modifier($0) }
//    }
}
