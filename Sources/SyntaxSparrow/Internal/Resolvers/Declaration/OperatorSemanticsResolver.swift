//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `OperatorDeclSyntax` node.
/// It exposes the expected properties of a `Operator` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct OperatorSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = OperatorDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: OperatorDeclSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Pending Obsoletion

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.identifier.text.trimmed
    }

    func resolveKeyword() -> String {
        node.operatorKeyword.text.trimmed
    }

    func resolveKind() -> Operator.Kind? {
        Operator.Kind(resolveModifiers())
        // Pending update - leaving here for easier reference
        // Operator.Kind(node.fixity)
    }
}
