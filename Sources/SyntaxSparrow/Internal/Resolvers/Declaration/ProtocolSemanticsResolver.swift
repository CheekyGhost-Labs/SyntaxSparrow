//
//  ProtocolSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `ProtocolDeclSyntax` node.
/// It exposes the expected properties of a `Protocol` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class ProtocolSemanticsResolver: DeclarationSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = ProtocolDeclSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = .init()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var inheritance: [String] = resolveInheritance()

    private(set) lazy var primaryAssociatedTypes: [String] = resolvePrimaryAssociatedTypes()

    private(set) lazy var genericRequirements: [GenericRequirement] = resolveGenericRequirements()

    private(set) lazy var associatedTypes: [AssociatedType] = resolveAssociatedTypes()

    // MARK: - Lifecycle

    required init(node: ProtocolDeclSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveName() -> String {
        node.identifier.text.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveKeyword() -> String {
        node.protocolKeyword.text.trimmed
    }

    private func resolveAssociatedTypes() -> [AssociatedType] {
        let collector = context.protocolAssociatedTypeCollector()
        return collector.collect(from: node)
    }

    private func resolvePrimaryAssociatedTypes() -> [String] {
        guard let clause = node.primaryAssociatedTypeClause else { return [] }
        return clause.primaryAssociatedTypeList.map { $0.name.text.trimmed }
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveInheritance() -> [String] {
        guard let inheritanceNode = node.inheritanceClause else { return [] }
        let types = inheritanceNode.inheritedTypeCollection.map { $0.typeName.description.trimmed }
        return types
    }

    private func resolveGenericRequirements() -> [GenericRequirement] {
        let requirements = GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirementList)
        return requirements
    }
}
