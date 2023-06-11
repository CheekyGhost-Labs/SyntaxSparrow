//
//  StructureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `ConditionalCompilationBlockBranchSemanticsResolver` conforming class that is responsible for exploring, retrieving properties,
/// and child branches of a `IfConfigDeclSyntax` node.
/// It exposes the expected properties of a `ConditionalCompilationBlock` as `lazy` properties. This will allow the initial lazy evaluation to not be
/// repeated when accessed repeatedly.
class ConditionalCompilationBlockBranchSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = IfConfigClauseSyntax

    let node: Node

    private(set) var declarationCollection: DeclarationCollection = .init()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var condition: String? = resolveCondition()

    // MARK: - Lifecycle

    required init(node: IfConfigClauseSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveKeyword() -> String {
        node.poundKeyword.text.trimmed
    }

    private func resolveCondition() -> String? {
        node.condition?.description.trimmed
    }
}
