//
//  ConditionalCompilationBlock.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift conditional compilation block declaration.
///
/// Conditional compilation blocks are used to conditionally compile parts of the program
/// based on the evaluation of one or more conditions.
/// Swift uses the keywords `#if`, `#elseif`, `#else`, and `#endif` to define these blocks.
///
/// Each instance of ``SyntaxSparrow/ConditionalCompilationBlock`` corresponds to a `ConditionalCompilationBlock` node in the Swift syntax tree.
///
/// This struct provides access to the branches within the conditional compilation block
/// and the source location of the block.
public struct ConditionalCompilationBlock: Declaration, SyntaxSourceLocationResolving {

    // MARK: - Properties

    /// Array of conditional compilation block branches.
    ///
    /// For example, in  the following declaration the block has three branches
    /// ```swift
    /// #if true
    /// enum A {}
    /// #elseif UNIT_TEST
    /// enum Test {}
    /// #else
    /// enum B {}
    /// #endif
    /// ```
    /// - The first branch has the keyword `#if` and the condition `true`
    /// - The first branch has the keyword `#elseif` and the condition `UNIT_TEST` (compiler flag presence)
    /// - The second branch has the keyword `#else` and no condition
    public var branches: [Branch] { resolver.branches }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: ConditionalCompilationBlockSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/ConditionalCompilationBlock`` instance from an `IfConfigDeclSyntax` node.
    public init(node: IfConfigDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = ConditionalCompilationBlockSemanticsResolver(node: node, context: context)
        // Resolving branches now to collect any declarations within (collection happens on init of branch)
        _ = branches
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        // no-op
    }

    // MARK: - Equatable

    public static func == (lhs: ConditionalCompilationBlock, rhs: ConditionalCompilationBlock) -> Bool {
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
