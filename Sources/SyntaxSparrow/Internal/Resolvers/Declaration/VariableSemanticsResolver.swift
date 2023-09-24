//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `PatternBindingSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct VariableSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = PatternBindingSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: PatternBindingSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAccessors() -> [Accessor] {
        guard let accessor = node.accessorBlock?.as(AccessorBlockSyntax.self) else { return [] }
        switch accessor.accessors {
        case .accessors(let accessorList):
            return accessorList.map(Accessor.init)
        default:
            return []
        }
    }

    func resolveType() -> EntityType {
        guard let typeAnnotation = node.typeAnnotation?.type else {
            guard
                let parent = node.parent?.as(PatternBindingListSyntax.self),
                let matchingType = parent.first(where: { $0.typeAnnotation != nil })?.typeAnnotation
            else {
                return .empty
            }
            return EntityType(matchingType.type)
        }
        return EntityType(typeAnnotation)
    }

    func resolveName() -> String {
        node.pattern.description.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return [] }
        return Attribute.fromAttributeList(parent.attributes)
    }

    func resolveKeyword() -> String {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return "" }
        return parent.bindingSpecifier.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        guard let parent = node.context?.as(VariableDeclSyntax.self) else { return [] }
        return parent.modifiers.map { Modifier(node: $0) }
    }

    func resolveInitializedValue() -> String? {
        node.initializer?.value.description.trimmed
    }

    func resolveIsOptional() -> Bool {
        guard let typeNode = node.typeAnnotation else { return false }
        return typeNode.type.resolveIsSyntaxOptional()
    }

    func resolveHasSetter() -> Bool {
        // If setter exists in accessors can return true
        if resolveAccessors().contains(where: { $0.kind == .set }) {
            return true
        }
        // Otherwise if the keyword is not `let` (immutable)
        guard resolveKeyword() != "let" else { return false }
        // Check if modifiers contain a private set
        guard !resolveModifiers().contains(where: { $0.name == "private" && $0.detail == "set" }) else { return false }
        // Finally if the root context is not a protocol, and the keyword is var, it can have a setter
        return node.context?.as(ProtocolDeclSyntax.self) == nil && resolveKeyword() == "var"
    }
}
