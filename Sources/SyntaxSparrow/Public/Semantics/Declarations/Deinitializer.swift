//
//  Deinitializer.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift deinitializer declaration.
///
/// Deinitializers are called automatically, just before an instance of a class is deallocated.
/// These are used to free up any resources that the class might have assigned.
/// In Swift, every class has at most one deinitializer per class.
/// The deinitializer does not carry a name and is written using the `deinit` keyword.
///
/// Each instance of ``SyntaxSparrow/Deinitializer`` corresponds to a `DeinitializerDeclSyntax` node in the Swift syntax tree.
///
/// This struct provides access to the deinitializer attributes, modifiers, keyword, and source location.
public struct Deinitializer: Declaration, SyntaxSourceLocationResolving {
    // MARK: - Properties: Computed

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"class"`
    public var keyword: String { resolver.keyword }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: DeinitializerSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Deinitializer`` instance from an `DeinitializerDeclSyntax` node.
    public init(node: DeinitializerDeclSyntax, context: SyntaxExplorerContext) {
        resolver = DeinitializerSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: Deinitializer, rhs: Deinitializer) -> Bool {
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
