//
//  StructureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `TypealiasDeclSyntax` node.
/// It exposes the expected properties of a `Typealias` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct TypealiasSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TypealiasDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: TypealiasDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.identifier.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.typealiasKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveInitializedType() -> EntityType {
        EntityType.parseType(node.initializer.value)
    }

    func resolveInitializedTypeIsOptional() -> Bool {
        node.initializer.value.resolveIsTypeOptional()
    }

    func resolveGenericParameters() -> [GenericParameter] {
        let parameters = GenericParameter.fromParameterList(from: node.genericParameterClause?.genericParameterList)
        return parameters
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }
}
