//
//  ProtocolSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `ProtocolDeclSyntax` node.
/// It exposes the expected properties of a `Protocol` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct ProtocolSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = ProtocolDeclSyntax

    let node: Node

    var viewMode: SyntaxTreeViewMode

    // MARK: - Lifecycle

    init(node: ProtocolDeclSyntax) {
        self.node = node
        viewMode = .fixedUp
    }

    init(node: ProtocolDeclSyntax, viewMode: SyntaxTreeViewMode = .fixedUp) {
        self.node = node
        self.viewMode = viewMode
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.protocolKeyword.text.trimmed
    }

    func resolveAssociatedTypes() -> [AssociatedType] {
        let collector = ProtocolAssociatedTypeCollector(viewMode: viewMode)
        return collector.collect(from: node)
    }

    func resolvePrimaryAssociatedTypes() -> [String] {
        guard let clause = node.primaryAssociatedTypeClause else { return [] }
        return clause.primaryAssociatedTypes.map { $0.name.text.trimmed }
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveInheritance() -> [String] {
        guard let inheritanceNode = node.inheritanceClause else { return [] }
        let types = inheritanceNode.inheritedTypes.map { $0.type.description.trimmed }
        return types
    }

    func resolveGenericRequirements() -> [GenericRequirement] {
        GenericRequirement.fromRequirementList(from: node.genericWhereClause?.requirements)
    }
}
