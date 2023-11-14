//
//  Array.swift
//  
//
//  Created by Michael O'Brien on 14/11/2023.
//

import Foundation
import SwiftSyntax

/// Represents a Swift `Array` type.
///
/// In Swift, arrays are used to store ordered collections of values. The `DictionaryDecl` struct
/// encapsulates an array type from a Swift source file and provides access to the element type.
///
/// The element type is represented as an `EntityType` instance. For example, for the dictionary
/// type `Dictionary<String, Int>` or `[String: Int]`, the key type would be `.simple("String")` and the
/// element type would be `.simple("Int")`.
///
/// This struct provides functionality to create an `DictionaryDecl` instance from either an `DictionaryTypeSyntax` node
/// or a `IdentifierTypeSyntax` node with `Dictionary` as the identifier. The struct also distinguishes between
/// arrays declared using square brackets (e.g., `[String: String]`) and those declared using the `Dictionary` keyword
/// with generics (e.g., `Dictionary<String, String>`).
///
/// The `DictionaryDecl` struct supports parsing both shorthand syntax `[Type: Type]` and full generic
/// form `Dictionary<Type, Type>` of Swift arrays.
/// This capability is essential for source code analysis where understanding the exact type of array elements is crucial.
public struct DictionaryDecl: Hashable, Equatable, CustomStringConvertible {

    // MARK: - Supplementary

    public enum DeclType: String, CaseIterable {
        /// The array was declared using the left/right square brackets. i.e `[String]`
        case shorthand
        /// The array was declared using the `Array` keyword with a generic parameter. i.e `Array<String>`
        case keyword
    }

    // MARK: - Properties

    /// The key type declared within the dictionary.
    ///
    /// For example, in the type `Dictionary<String, String>` or `[String: String]` the key type will be `.simple("String")`
    public var keyType: EntityType { resolver.resolveElementType() }

    /// The value type declared within the dictionary.
    ///
    /// For example, in the type `Dictionary<String, String>` or `[String: String]` the element type will be `.simple("String")`
    public var valueType: EntityType { resolver.resolveElementType() }

    /// `Bool` whether the result type is optional.
    ///
    /// For example, `Dictionary<String, String>?` or `[String: String]?` has `isOptional` as `true`.
    public var isOptional: Bool { resolver.resolveIsOptional() }
    
    /// The declaration type for the array.
    /// - See: ``DeclType``
    public var declType: DeclType

    // MARK: - Properties: Convenience

    private(set) var resolver: any ArraySemanticsResolving

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/DictionaryDecl`` instance from an `IdentifierTypeSyntax` node.
    ///
    /// **Note:** Will return `nil` if the `node.firstToken.tokenKind` is not `Result`
    public init?(_ node: IdentifierTypeSyntax) {
        guard node.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Dictionary") else { return nil }
        resolver = DictionaryIdentifierSemanticsResolver(node: node)
        declType = .keyword
    }

    public init(_ node: DictionaryTypeSyntax) {
        resolver = DictionaryTypeSemanticsResolver(node: node)
        declType = .shorthand
    }

    // MARK: - Equatable

    public static func == (lhs: DictionaryDecl, rhs: DictionaryDecl) -> Bool {
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
