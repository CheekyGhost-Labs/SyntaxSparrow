//
//  Array.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift `Array` type.
///
/// In Swift, arrays are used to store ordered collections of values. The `ArrayDecl` struct
/// encapsulates an array type from a Swift source file and provides access to the element type.
///
/// The element type is represented as an `EntityType` instance. For example, for the array type `Array<String>`
/// or `[String]`, the element type will be `.simple("String")`.
///
/// This struct provides functionality to create an `ArrayDecl` instance from either an `ArrayTypeSyntax` node
/// or a `IdentifierTypeSyntax` node with `Array` as the identifier. The struct also distinguishes between
/// arrays declared using square brackets (e.g., `[String]`) and those declared using the `Array` keyword
/// with generics (e.g., `Array<String>`).
///
/// The `ArrayDecl` struct supports parsing both shorthand syntax `[Type]` and full generic form `Array<Type>` of Swift arrays.
/// This capability is essential for source code analysis where understanding the exact type of array elements is crucial.
public struct ArrayDecl: Hashable, Equatable, CustomStringConvertible {

    // MARK: - Supplementary

    public enum DeclType: String, CaseIterable {
        /// The array was declared using the left/right square brackets. i.e `[String]`
        case squareBrackets
        /// The array was declared using the `Array` keyword with generic parameter. i.e `Array<String>`
        case generic
    }

    // MARK: - Properties

    /// The element type declared within the array.
    ///
    /// For example, in the type `Array<String>` or `[String]` the type will be `.simple("String")`
    public var elementType: EntityType { resolver.resolveElementType() }

    /// `Bool` whether the array decl is optional.
    ///
    /// For example, `Array<String>?` has `isOptional` as `true`.
    public var isOptional: Bool { resolver.resolveIsOptional() }
    
    /// The declaration type for the array.
    /// - See: ``DeclType``
    public let declType: DeclType

    // MARK: - Properties: Convenience

    private(set) var resolver: any ArraySemanticsResolving

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/ArrayDecl`` instance from an `IdentifierTypeSyntax` node.
    ///
    /// **Note:** Will return `nil` if the `node.firstToken.tokenKind` is not `.identifier("Array")`
    public init?(_ node: IdentifierTypeSyntax) {
        guard node.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Array") else { return nil }
        resolver = ArrayIdentifierSemanticsResolver(node: node)
        declType = .generic
    }

    public init(_ node: ArrayTypeSyntax) {
        resolver = ArrayTypeSemanticsResolver(node: node)
        declType = .squareBrackets
    }

    // MARK: - Equatable

    public static func == (lhs: ArrayDecl, rhs: ArrayDecl) -> Bool {
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
