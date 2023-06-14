//
//  AssociatedTypeSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `AssociatedtypeDeclSyntax` node.
/// It exposes the expected properties of a `AssociatedType` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct AssociatedTypeSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = AssociatedtypeDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: AssociatedtypeDeclSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op - log?
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.identifier.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.associatedtypeKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveInheritance() -> [String] {
        guard let inheritanceNode = node.inheritanceClause else { return [] }
        let types = inheritanceNode.inheritedTypeCollection.map { $0.typeName.description.trimmed }
        return types
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }
}
