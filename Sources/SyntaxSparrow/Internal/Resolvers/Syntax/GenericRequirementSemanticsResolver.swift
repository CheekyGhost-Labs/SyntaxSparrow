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
        switch node.body {
        case let .sameTypeRequirement(syntax):
            return syntax.leftTypeIdentifier.description.trimmed
        case let .conformanceRequirement(syntax):
            return syntax.leftTypeIdentifier.description.trimmed
        case .layoutRequirement:
            return "Self"
        }
    }

    func resolveRightType() -> String {
        switch node.body {
        case let .sameTypeRequirement(syntax):
            return syntax.rightTypeIdentifier.description.trimmed
        case let .conformanceRequirement(syntax):
            return syntax.rightTypeIdentifier.description.trimmed
        case let .layoutRequirement(syntax):
            return syntax.typeIdentifier.description.trimmed
        }
    }

    func resolveRelation() -> GenericRequirement.Relation {
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
