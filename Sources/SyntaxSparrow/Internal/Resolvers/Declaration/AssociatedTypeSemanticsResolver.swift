//
//  AssociatedTypeSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `AssociatedTypeDeclSyntax` node.
/// It exposes the expected properties of a `AssociatedType` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct AssociatedTypeSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = AssociatedTypeDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: AssociatedTypeDeclSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op - log?
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.associatedtypeKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveInheritance() -> [String] {
        guard let inheritanceNode = node.inheritanceClause else { return [] }
        let types = inheritanceNode.inheritedTypes.map { $0.type.description.trimmed }
        return types
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
        return requirements
    }
}
