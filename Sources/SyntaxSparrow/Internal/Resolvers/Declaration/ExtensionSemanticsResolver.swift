//
//  ExtensionSemanticsResolver.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `StructDeclSyntax` node.
/// It exposes the expected properties of a `Structure` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class ExtensionSemanticsResolver: DeclarationSemanticsResolving {

    // MARK: - Properties: DeclarationSemanticsResolving
    typealias Node = ExtensionDeclSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = DeclarationCollection()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var extendedType: String = resolveExtendedType()

    private(set) lazy var inheritance: [String] = resolveInheritance()

    private(set) lazy var genericRequirements: [GenericRequirement] = resolveGenericRequirements()

    // MARK: - Lifecycle

    required init(node: ExtensionDeclSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    func collectChildren() {
        let nodeCollector = context.createRootDeclarationCollector()
        declarationCollection = nodeCollector.collect(fromNode: node)
    }

    // MARK: - Resolvers

    private func resolveExtendedType() -> String {
        node.extendedType.description.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveKeyword() -> String {
        node.extensionKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier($0) }
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
