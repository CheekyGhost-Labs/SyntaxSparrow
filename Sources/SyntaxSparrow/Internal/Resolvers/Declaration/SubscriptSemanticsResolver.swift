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
        node.parameterClause.parameters.map { Parameter(node: $0) }
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.subscriptKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveGenericParameters() -> [GenericParameter] {
        GenericParameter.fromParameterList(from: node.genericParameterClause?.parameters)
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
    }

    func resolveReturnType() -> EntityType {
        EntityType(node.returnClause.type)
    }

    func resolveReturnTypeIsOptional() -> Bool {
        node.returnClause.type.resolveIsTypeOptional()
    }

    func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessorBlock?.as(AccessorBlockSyntax.self) else { return [] }
        switch accessor.accessors {
        case .accessors(let accessorList):
            return accessorList.map(Accessor.init)
        default:
            return []
        }
    }
}
