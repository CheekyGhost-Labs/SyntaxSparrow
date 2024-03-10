//
//  File.swift
//  
//
//  Created by Michael O'Brien on 14/11/2023.
//

import Foundation
import SwiftSyntax

/// Represents a Swift `Set` type.
///
/// In Swift, sets are used to store unique collections of values. The `SetDecl` struct
/// encapsulates an set type from a Swift source file and provides access to the element type.
///
/// The element type is represented as an `EntityType` instance. For example, for the set type `Set<String>`,
/// the element type will be `.simple("String")`.
///
/// This struct provides functionality to create an `SetDecl` instance from an `ArrayTypeSyntax`
/// `IdentifierTypeSyntax` node with `Set` as the identifier.
///
/// This capability is essential for source code analysis where understanding the exact type of set element is crucial.
public struct SetDecl: Hashable, Equatable, CustomStringConvertible {

    // MARK: - Properties

    /// The element type declared within the set.
    ///
    /// For example, in the type `Set<String>`, the `entityType` will be `.simple("String")`
    public var elementType: EntityType { resolver.resolveElementType() }

    /// `Bool` whether the result type is optional.
    ///
    /// For example, `Set<String>?` has `isOptional` as `true`.
    public var isOptional: Bool { resolver.resolveIsOptional() }

    // MARK: - Properties: Convenience

    private(set) var resolver: SetSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/SetDecl`` instance from a `IdentifierTypeSyntax` node.
    ///
    /// **Note:** Will return `nil` if the `node.firstToken.tokenKind` is not `Result`
    public init?(_ node: IdentifierTypeSyntax) {
        guard node.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Set") else { return nil }
        resolver = SetSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: SetDecl, rhs: SetDecl) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        let base = resolver.node.description.trimmed
        return base + (isOptional ? "?" : "")
    }
}
