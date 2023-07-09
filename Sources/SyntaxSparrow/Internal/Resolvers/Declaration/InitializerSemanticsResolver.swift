//
//  InitializerSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `InitializerDeclSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct InitializerSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = InitializerDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: InitializerDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveKeyword() -> String {
        node.initKeyword.text.trimmed
    }

    func resolveIsOptional() -> Bool {
        node.optionalMark != nil
    }

    func resolveGenericParameters() -> [GenericParameter] {
        let parameters = GenericParameter.fromParameterList(from: node.genericParameterClause?.genericParameterList)
        return parameters
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }

    func resolveParameters() -> [Parameter] {
        node.signature.input.parameterList.map(Parameter.init)
    }

    func resolveThrowsOrRethrowsKeyword() -> String? {
        node.signature.effectSpecifiers?.throwsSpecifier?.text.trimmed
    }

    func resolveEffectSpecifiers() -> EffectSpecifiers? {
        guard let specifiers = node.signature.effectSpecifiers else { return nil }
        return EffectSpecifiers(node: specifiers)
    }

    func resolveBody() -> CodeBlock? {
        guard let body = node.body else { return nil }
        return CodeBlock(node: body)
    }
}
