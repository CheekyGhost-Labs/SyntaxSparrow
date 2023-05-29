//
//  ConditionalCompilationBlock.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `ConditionalCompilationBlock` is a struct representing a Swift conditional compilation block declaration. This struct is part of the SyntaxSparrow library, which provides an
/// interface for traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Function` corresponds to a `FunctionDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties.
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
