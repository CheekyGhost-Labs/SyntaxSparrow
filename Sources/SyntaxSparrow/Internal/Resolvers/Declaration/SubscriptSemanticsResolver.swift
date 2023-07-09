//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `SubscriptDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct SubscriptSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = SubscriptDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: SubscriptDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveIndices() -> [Parameter] {
        node.indices.parameterList.map { Parameter(node: $0) }
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.subscriptKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveGenericParameters() -> [GenericParameter] {
        let parameters = GenericParameter.fromParameterList(from: node.genericParameterClause?.genericParameterList)
        return parameters
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }

    func resolveReturnType() -> EntityType {
        EntityType(node.result.returnType)
    }

    func resolveReturnTypeIsOptional() -> Bool {
        node.result.returnType.resolveIsTypeOptional()
    }

    func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessor?.as(AccessorBlockSyntax.self) else { return [] }
        return accessor.accessors.map(Accessor.init)
    }
}
