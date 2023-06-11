//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `FunctionDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class FunctionSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = FunctionDeclSyntax

    let node: Node

    private(set) var declarationCollection: DeclarationCollection = .init()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var identifier: String = resolveIdentifier()

    private(set) lazy var genericParameters: [GenericParameter] = resolveGenericParameters()

    private(set) lazy var genericRequirements: [GenericRequirement] = resolveGenericRequirements()

    private(set) lazy var isOperator: Bool = resolveIsOperator()

    private(set) lazy var operatorKind: Operator.Kind? = resolveOperatorKind()

    private(set) lazy var signature: Function.Signature = resolveSignature()

    // MARK: - Lifecycle

    required init(node: FunctionDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveIdentifier() -> String {
        node.identifier.text.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveKeyword() -> String {
        node.funcKeyword.text.trimmed
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

    private func resolveIsOperator() -> Bool {
        Operator.Kind(modifiers) != nil || Operator.isValidIdentifier(identifier)
    }

    private func resolveSignature() -> Function.Signature {
        let inputParameters = node.signature.input.parameterList.map(Parameter.init)
        var outputType: EntityType?
        if let output = node.signature.output {
            outputType = EntityType.parseType(output.returnType)
        }
        let throwsKeyword = node.signature.effectSpecifiers?.throwsSpecifier?.text.trimmed
        return Function.Signature(input: inputParameters, output: outputType, throwsOrRethrowsKeyword: throwsKeyword)
    }

    private func resolveOperatorKind() -> Operator.Kind? {
        guard isOperator else { return nil }
        return Operator.Kind(modifiers) ?? .infix
    }
}
