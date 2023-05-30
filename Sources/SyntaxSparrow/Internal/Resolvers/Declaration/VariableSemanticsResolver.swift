//
//  FunctionSemanticsResolver.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `PatternBindingSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class VariableSemanticsResolver: DeclarationSemanticsResolving {

    // MARK: - Properties: DeclarationSemanticsResolving
    typealias Node = PatternBindingSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = DeclarationCollection()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var type: EntityType = resolveEntityType()

    private(set) lazy var initializedValue: String? = resolveInitializedValue()

    private(set) lazy var accessors: [Accessor] = resolveAccessors()

    // MARK: - Lifecycle

    required init(node: PatternBindingSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessor?.as(AccessorBlockSyntax.self) else { return [] }
        return accessor.accessors.map(Accessor.init)
    }

    private func resolveEntityType() -> EntityType {
        guard let typeAnnotation = node.typeAnnotation?.type else { return .empty }
        return EntityType.parseType(typeAnnotation)
    }

    private func resolveName() -> String {
        node.pattern.description.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        guard let parent = node.parent?.as(VariableDeclSyntax.self) else { return [] }
        return Attribute.fromAttributeList(parent.attributes)
    }

    private func resolveKeyword() -> String {
        guard let parent = node.parent?.as(VariableDeclSyntax.self) else { return "" }
        return parent.letOrVarKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let parent = node.parent?.as(VariableDeclSyntax.self) else { return [] }
        guard let modifierList = parent.modifiers else { return [] }
        return modifierList.map { Modifier($0) }
    }

    private func resolveInitializedValue() -> String? {
        node.initializer?.value.description.trimmed
    }
}
