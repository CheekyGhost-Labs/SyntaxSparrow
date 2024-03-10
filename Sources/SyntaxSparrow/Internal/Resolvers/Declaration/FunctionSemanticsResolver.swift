//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `FunctionDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct FunctionSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = FunctionDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: FunctionDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveIdentifier() -> String {
        node.name.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.funcKeyword.text.trimmed
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

    func resolveIsOperator() -> Bool {
        Operator.Kind(resolveModifiers()) != nil || Operator.isValidIdentifier(resolveIdentifier())
    }

    func resolveSignature() -> Function.Signature {
        let inputParameters = node.signature.parameterClause.parameters.map(Parameter.init)
        var outputType: EntityType?
        var isOutputOptional: Bool = false
        if let output = node.signature.returnClause {
            outputType = EntityType(output.type)
            isOutputOptional = output.type.resolveIsTypeOptional()
        }

        var effectSpecifiers: EffectSpecifiers?
        if let specifiers = node.signature.effectSpecifiers {
            effectSpecifiers = EffectSpecifiers(node: specifiers)
        }
        return Function.Signature(
            node: node.signature,
            input: inputParameters,
            output: outputType,
            outputIsOptional: isOutputOptional,
            effectSpecifiers: effectSpecifiers
        )
    }

    func resolveOperatorKind() -> Operator.Kind? {
        guard resolveIsOperator() else { return nil }
        return Operator.Kind(resolveModifiers()) ?? .infix
    }

    func resolveBody() -> CodeBlock? {
        guard let body = node.body else { return nil }
        return CodeBlock(node: body)
    }
}
