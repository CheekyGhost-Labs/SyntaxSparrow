//
//  InitializerSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `InitializerDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class InitializerSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = InitializerDeclSyntax

    let node: Node

    private(set) var declarationCollection: DeclarationCollection = .init()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var isOptional: Bool = resolveIsOptional()

    private(set) lazy var genericParameters: [GenericParameter] = resolveGenericParameters()

    private(set) lazy var genericRequirements: [GenericRequirement] = resolveGenericRequirements()

    private(set) lazy var parameters: [Parameter] = resolveParameters()

    private(set) lazy var throwsOrRethrowsKeyword: String? = resolveThrowsOrRethrowsKeyword()

    // MARK: - Lifecycle

    required init(node: InitializerDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveKeyword() -> String {
        node.initKeyword.text.trimmed
    }

    private func resolveIsOptional() -> Bool {
        node.optionalMark != nil
    }

    private func resolveGenericParameters() -> [GenericParameter] {
        let parameters = GenericParameter.fromParameterList(from: node.genericParameterClause?.genericParameterList)
        return parameters
    }

    private func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }

    private func resolveParameters() -> [Parameter] {
        node.signature.input.parameterList.map(Parameter.init)
    }

    private func resolveThrowsOrRethrowsKeyword() -> String? {
        node.signature.effectSpecifiers?.throwsSpecifier?.text.trimmed
    }
}
