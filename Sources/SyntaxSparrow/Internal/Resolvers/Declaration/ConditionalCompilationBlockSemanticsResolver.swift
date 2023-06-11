//
//  StructureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `ConditionalCompilationBlockSemanticsResolver` conforming class that is responsible for exploring, retrieving properties,
/// and child branches of a `IfConfigDeclSyntax` node.
/// It exposes the expected properties of a `ConditionalCompilationBlock` as `lazy` properties. This will allow the initial lazy evaluation to not be
/// repeated when accessed repeatedly.
class ConditionalCompilationBlockSemanticsResolver: DeclarationSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = IfConfigDeclSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = .init()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var branches: [ConditionalCompilationBlock.Branch] = resolveBranches()

    // MARK: - Lifecycle

    required init(node: IfConfigDeclSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveBranches() -> [ConditionalCompilationBlock.Branch] {
        node.clauses.map { ConditionalCompilationBlock.Branch(node: $0, context: context) }
    }
}
