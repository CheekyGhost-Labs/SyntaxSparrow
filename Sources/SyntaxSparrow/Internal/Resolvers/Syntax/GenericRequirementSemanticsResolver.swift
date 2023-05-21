//
//  GenericRequirementSemanticsResolver.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `GenericRequirementSyntax` node.
/// It exposes the expected properties of a `GenericRequirement` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class GenericRequirementSemanticsResolver: NodeSemanticsResolving {

    // MARK: - Properties: DeclarationSemanticsResolving
    typealias Node = GenericRequirementSyntax

    let node: Node

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var relation: GenericRequirement.Relation = resolveRelation()

    private(set) lazy var leftTypeIdentifier: String = resolveLeftType()

    private(set) lazy var rightTypeIdentifier: String = resolveRightType()

    // MARK: - Lifecycle

    required init(node: GenericRequirementSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveLeftType() -> String {
        switch node.body {
        case .sameTypeRequirement(let syntax):
            return syntax.leftTypeIdentifier.description.trimmed
        case .conformanceRequirement(let syntax):
            return syntax.leftTypeIdentifier.description.trimmed
        case .layoutRequirement:
            return "Self"
        }
    }

    private func resolveRightType() -> String {
        switch node.body {
        case .sameTypeRequirement(let syntax):
            return syntax.rightTypeIdentifier.description.trimmed
        case .conformanceRequirement(let syntax):
            return syntax.rightTypeIdentifier.description.trimmed
        case .layoutRequirement(let syntax):
            return syntax.typeIdentifier.description.trimmed
        }
    }

    private func resolveRelation() -> GenericRequirement.Relation {
        switch node.body {
        case .sameTypeRequirement:
            return .sameType
        case .conformanceRequirement:
            return .conformance
        case .layoutRequirement:
            return .layout
        }
    }
}
