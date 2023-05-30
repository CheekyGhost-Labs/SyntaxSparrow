//
//  Import.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift import declaration.
///
/// In Swift, the `import` keyword is used to import a module, which makes the module's
/// public types, protocols, and functions available in your code.
///
/// For example, in the declaration `import SyntaxSparrow.Protocol`, the module `SyntaxSparrow.Protocol` is imported.
///
/// Each instance of ``SyntaxSparrow/Import`` corresponds to an `ImportDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration` and `SyntaxSourceLocationResolving`, which provide
/// access to the declaration attributes, modifiers, and source location information.
public struct Import: Declaration, SyntaxSourceLocationResolving {

    // MARK: - Properties
    
    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"import"` for import declarations
    public var keyword: String { resolver.keyword }

    /// Optional kind of the import.
    ///
    /// Specifies the type of symbol being imported from the module.
    /// For example, `import struct SyntaxSparrow.Protocol` would have a kind of `"struct`.
    public var kind: String? { resolver.kind }

    /// The import access path components.
    ///
    /// Represents the hierarchical names used to specify the module to import.
    /// For example, `import SyntaxSparrow.Protocol` would have path components of `["SyntaxSparrow", "Protocol"]`.
    public var pathComponents: [String] { resolver.pathComponents }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: ImportSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Import`` instance from an `ImportDeclSyntax` node.
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
