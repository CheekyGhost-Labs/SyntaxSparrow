//
//  Deinitializer.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Deinitializer` is a class representing a class `deinit` declaration. This class is part of the `SyntaxSparrow` library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a protocol declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Deinitializer` corresponds to a `DeinitializerDeclSyntax` node in the Swift syntax tree.
///
/// `Protocol` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the protocol in the source code is captured in `sourceLocation` via the `SyntaxSourceLocationResolving` protocol.
public class Deinitializer: Declaration, SyntaxSourceLocationResolving {

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

    public init(node: DeinitializerDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = DeinitializerSemanticsResolver(node: node, context: context)
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
