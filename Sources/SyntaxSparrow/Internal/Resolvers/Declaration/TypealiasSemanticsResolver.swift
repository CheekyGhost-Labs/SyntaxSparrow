//
//  StructureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `TypeAliasDeclSyntax` node.
/// It exposes the expected properties of a `Typealias` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct TypealiasSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TypeAliasDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: TypeAliasDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.typealiasKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveInitializedType() -> EntityType {
        EntityType(node.initializer.value)
    }

    func resolveInitializedTypeIsOptional() -> Bool {
        node.initializer.value.resolveIsTypeOptional()
    }

    func resolveGenericParameters() -> [GenericParameter] {
        GenericParameter.fromParameterList(from: node.genericParameterClause?.parameters)
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
    }
}
