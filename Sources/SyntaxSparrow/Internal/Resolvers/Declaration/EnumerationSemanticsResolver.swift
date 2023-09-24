//
//  EnumerationSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `EnumDeclSyntax` node.
/// It exposes the expected properties of a `Enumeration` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct EnumerationSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = EnumDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: EnumDeclSyntax) {
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
        node.enumKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveInheritance() -> [String] {
        guard let inheritanceNode = node.inheritanceClause else { return [] }
        let types = inheritanceNode.inheritedTypes.map { $0.type.description.trimmed }
        return types
    }

    func resolveGenericParameters() -> [GenericParameter] {
        GenericParameter.fromParameterList(from: node.genericParameterClause?.parameters)
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
        return requirements
    }

    func resolveCases() -> [Enumeration.Case] {
        let caseNodes = node.memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
        return caseNodes.flatMap { caseDecl in
            caseDecl.elements.map { Enumeration.Case(node: $0) }
        }
    }
}
