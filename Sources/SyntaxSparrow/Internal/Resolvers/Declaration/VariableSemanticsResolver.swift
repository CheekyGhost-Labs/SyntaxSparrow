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
        guard let accessor = node.accessorBlock else { return [] }
        switch accessor.accessors {
        case .accessors(let accessorList):
            return accessorList.map(Accessor.init)
        default:
            return []
        }
    }
    
    /// Used to determine if there is a code block returning a value present
    ///
    /// i.e
    /// ```swift
    /// var name: String { "example" }
    /// var other: String {
    ///     let count = 5
    ///     return "Count: \(count)"
    /// }
    /// ```
    /// - Returns: Bool
    func resolveHasCodeBlockItems() -> Bool {
        guard
            let accessor = node.accessorBlock,
            let codeBlockList = accessor.accessors.as(CodeBlockItemListSyntax.self)
        else { return false }
        return !codeBlockList.isEmpty
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

    func resolveIsComputed() -> Bool {
        // If there is a value assigned - return false
        guard node.initializer == nil else { return false}
        // If there is a setter accessor - return false
        let hasSetter = resolveHasSetter()
        guard !hasSetter else { return false }
        // If getter accessor exists - return true
        let accessors = resolveAccessors()
        if accessors.contains(where: { $0.kind == .get }) {
            return true
        }
        // Otherwise check if there is a code block
        return node.accessorBlock != nil
    }

    func resolveHasSetter() -> Bool {
        // Resolver accessors for assessment
        let accessors = resolveAccessors()
        let accessorKinds = accessors.compactMap(\.kind)
        let hasSetterAccessor = accessorKinds.contains(where: { [.set, .willSet, .didSet].contains($0) })
        let hasEffectGetter = accessors.contains(where: {
            let hasSpecifier = ($0.effectSpecifiers?.throwsSpecifier != nil || $0.effectSpecifiers?.asyncSpecifier != nil)
            return $0.kind == .get && hasSpecifier
        })
        // Check if has throwing or async getter (no setter allowed)
        guard !hasEffectGetter else { return false }
        // If setter exists in accessors can return true (usually protocol context or manually written will/did/set accessor).
        if hasSetterAccessor { return true }
        // If no accessors, but a direct return/code block, can assume there is no setter
        if accessors.isEmpty, resolveHasCodeBlockItems() { return false }
        // Otherwise if the keyword is not `let` (immutable)
        guard resolveKeyword() != "let" else { return false }
        // Check if modifiers contain a private setter
        guard !resolveModifiers().contains(where: { $0.name == "private" && $0.detail == "set" }) else { return false }
        // Finally if the root context is not a protocol, and the keyword is var, it can have a setter
        let isPotential = node.firstParent(returning: { $0.as(ProtocolDeclSyntax.self )}) == nil && resolveKeyword() == "var"
        return isPotential
    }
}
