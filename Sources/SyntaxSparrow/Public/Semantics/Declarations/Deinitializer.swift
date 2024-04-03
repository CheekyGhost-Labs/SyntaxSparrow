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
public struct Deinitializer: Declaration, SyntaxChildCollecting {
    // MARK: - Properties: Declaration

    public var node: DeinitializerDeclSyntax { resolver.node }

    // MARK: - Properties: Computed

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"deinit"`
    public var keyword: String { resolver.resolveKeyword() }

    /// Struct representing the body of the function.
    ///
    /// For example in the following declaration:
    /// ```swift
    /// func deinit() {
    ///     print("hello")
    ///     print("world")
    /// }
    /// ```
    /// would provide a `body` that is not `nil` and would have 2 statements within it.
    public var body: CodeBlock? { resolver.resolveBody() }

    // MARK: - Properties: Resolving

    private(set) var resolver: DeinitializerSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    // Note: The `CodeBlock` type supports collecting child declarations. The deinit will default to using that collection.

    public var childCollection: DeclarationCollection {
        body?.childCollection ?? DeclarationCollection()
    }

    // MARK: - Lifecycle

    public init(node: DeinitializerDeclSyntax) {
        resolver = DeinitializerSemanticsResolver(node: node)
    }

    public func collectChildren(viewMode: SyntaxTreeViewMode) {
        body?.collectChildren(viewMode: viewMode)
    }
}
