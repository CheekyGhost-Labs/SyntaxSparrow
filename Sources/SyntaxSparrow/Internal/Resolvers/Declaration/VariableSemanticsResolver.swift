//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `PatternBindingSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class VariableSemanticsResolver: DeclarationSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = PatternBindingSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = .init()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var type: EntityType = resolveEntityType()

    private(set) lazy var initializedValue: String? = resolveInitializedValue()

    private(set) lazy var accessors: [Accessor] = resolveAccessors()

    private(set) lazy var isOptional: Bool = resolveIsOptional()

    private(set) lazy var hasSetter: Bool = resolveHasSetter()

    // MARK: - Lifecycle

    required init(node: PatternBindingSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
    }

    // MARK: - Resolvers

    private func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessor?.as(AccessorBlockSyntax.self) else { return [] }
        return accessor.accessors.map(Accessor.init)
    }

    private func resolveEntityType() -> EntityType {
        guard let typeAnnotation = node.typeAnnotation?.type else {
            guard
                let parent = node.parent?.as(PatternBindingListSyntax.self),
                let matchingType = parent.first(where: { $0.typeAnnotation != nil })?.typeAnnotation
            else {
                return .empty
            }
            return EntityType.parseType(matchingType.type)
        }
        return EntityType.parseType(typeAnnotation)
    }

    private func resolveName() -> String {
        node.pattern.description.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return [] }
        return Attribute.fromAttributeList(parent.attributes)
    }

    private func resolveKeyword() -> String {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return "" }
        return parent.bindingKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return [] }
        guard let modifierList = parent.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveInitializedValue() -> String? {
        node.initializer?.value.description.trimmed
    }

    private func resolveIsOptional() -> Bool {
        guard let typeNode = node.typeAnnotation else { return false }
        return typeNode.type.resolveIsOptional()
    }

    private func resolveHasSetter() -> Bool {
        // If setter exists in accessors can return true
        if accessors.contains(where: { $0.kind == .set }) {
            return true
        }
        // Otherwise if the keyword is not `let` (immutable)
        guard keyword != "let" else { return false }
        // Check if modifiers contain a private set
        guard !modifiers.contains(where: { $0.name == "private" && $0.detail == "set" }) else { return false }
        // Finally if the root context is not a protocol, and the keyword is var, it can have a setter
        return node.context?.as(ProtocolDeclSyntax.self) == nil && keyword == "var"
    }

    func resolveSourceLocation() -> SyntaxSourceLocation {
        if context.sourceLocationConverter.isEmpty {
            context.sourceLocationConverter.updateToRootForNode(node)
        }
        let targetNode: SyntaxProtocol = node.context ?? node
        let start = context.sourceLocationConverter.startLocationForNode(targetNode)
        let end = context.sourceLocationConverter.endLocationForNode(targetNode)
        return SyntaxSourceLocation(start: start, end: end)
    }
}
