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
        node.identifier.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.funcKeyword.text.trimmed
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

    func resolveIsOperator() -> Bool {
        Operator.Kind(resolveModifiers()) != nil || Operator.isValidIdentifier(resolveIdentifier())
    }

    func resolveSignature() -> Function.Signature {
        let inputParameters = node.signature.input.parameterList.map(Parameter.init)
        var outputType: EntityType?
        if let output = node.signature.output {
            outputType = EntityType.parseType(output.returnType)
        }
        let throwsKeyword = node.signature.effectSpecifiers?.throwsSpecifier?.text.trimmed
        let asyncKeyword = node.signature.effectSpecifiers?.asyncSpecifier?.text.trimmed
        return Function.Signature(
            input: inputParameters,
            output: outputType,
            throwsOrRethrowsKeyword: throwsKeyword,
            asyncKeyword: asyncKeyword
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
