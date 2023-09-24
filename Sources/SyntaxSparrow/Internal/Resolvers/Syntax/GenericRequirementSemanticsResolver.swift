//
//  GenericRequirementSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `GenericRequirementSyntax` node.
/// It exposes the expected properties of a `GenericRequirement` via resolving methods
struct GenericRequirementSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = GenericRequirementSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: GenericRequirementSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveLeftType() -> String {
        switch node.requirement {
        case let .sameTypeRequirement(syntax):
            return syntax.leftType.description.trimmed
        case let .conformanceRequirement(syntax):
            return syntax.leftType.description.trimmed
        case .layoutRequirement:
            return "Self"
        }
    }

    func resolveRightType() -> String {
        switch node.requirement {
        case let .sameTypeRequirement(syntax):
            return syntax.rightType.description.trimmed
        case let .conformanceRequirement(syntax):
            return syntax.rightType.description.trimmed
        case let .layoutRequirement(syntax):
            return syntax.type.description.trimmed
        }
    }

    func resolveRelation() -> GenericRequirement.Relation {
        switch node.requirement {
        case .sameTypeRequirement:
            return .sameType
        case .conformanceRequirement:
            return .conformance
        case .layoutRequirement:
            return .layout
        }
    }
}
