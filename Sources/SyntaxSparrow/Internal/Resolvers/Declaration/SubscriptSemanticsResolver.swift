//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `SubscriptDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class SubscriptSemanticsResolver: DeclarationSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = SubscriptDeclSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = .init()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var indices: [Parameter] = resolveIndices()

    private(set) lazy var genericParameters: [GenericParameter] = resolveGenericParameters()

    private(set) lazy var genericRequirements: [GenericRequirement] = resolveGenericRequirements()

    private(set) lazy var returnType: EntityType = resolveReturnType()

    private(set) lazy var accessors: [Accessor] = resolveAccessors()

    // MARK: - Lifecycle

    required init(node: SubscriptDeclSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveIndices() -> [Parameter] {
        node.indices.parameterList.map { Parameter(node: $0) }
    }

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveKeyword() -> String {
        node.subscriptKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveGenericParameters() -> [GenericParameter] {
        let parameters = GenericParameter.fromParameterList(from: node.genericParameterClause?.genericParameterList)
        return parameters
    }

    private func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }

    private func resolveReturnType() -> EntityType {
        EntityType.parseType(node.result.returnType)
    }

    private func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessor?.as(AccessorBlockSyntax.self) else { return [] }
        return accessor.accessors.map(Accessor.init)
    }
}
