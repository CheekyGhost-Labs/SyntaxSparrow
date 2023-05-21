//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// An import declaration.
public struct Import: Declaration, SyntaxSourceLocationResolving {

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"import"`
    public var keyword: String { resolver.keyword }

    /// Optional kind of the import.
    ///
    /// For example, `import struct SyntaxSparrow.Protocol` would be `"struct`
    public var kind: String? { resolver.kind }

    /// The import access path components.
    ///
    /// For example, `import SyntaxSparrow.Protocol` would be `["SyntaxSparrow", "Protocol"]`
    public var pathComponents: [String] { resolver.pathComponents }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: ImportSemanticsResolver

    // MARK: - Lifecycle

    public init(node: ImportDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = ImportSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: Import, rhs: Import) -> Bool {
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
