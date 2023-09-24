//
//  StructureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `StructDeclSyntax` node.
/// It exposes the expected properties of a `Structure` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct StructureSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = StructDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: StructDeclSyntax) {
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
        node.structKeyword.text.trimmed
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
        GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
    }
}
