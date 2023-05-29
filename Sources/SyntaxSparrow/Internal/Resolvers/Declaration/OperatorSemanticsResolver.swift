//
//  FunctionSemanticsResolver.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `OperatorDeclSyntax` node.
/// It exposes the expected properties of a `Operator` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class OperatorSemanticsResolver: DeclarationSemanticsResolving {

    // MARK: - Properties: DeclarationSemanticsResolving
    typealias Node = OperatorDeclSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = DeclarationCollection()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var kind: Operator.Kind? = resolveKind()

    // MARK: - Lifecycle

    required init(node: OperatorDeclSyntax, context: SyntaxExplorerContext) {
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
        node.operatorKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveKind() -> Operator.Kind? {
        Operator.Kind(modifiers)
    }
}
