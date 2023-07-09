//
//  ClosureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `NodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `TupleTypeSyntax`
/// node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct ClosureSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = FunctionTypeSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: FunctionTypeSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    func resolveInput() -> EntityType {
        guard !node.arguments.isEmpty else { return .void("()", false) }
        return EntityType.parseElementList(node.arguments)
        // Pending update - leaving here for easier reference
        // return EntityType.parseElementList(node.parameters)
    }

    func resolveOutput() -> EntityType {
        EntityType(node.output.returnType)
    }

    func resolveRawInput() -> String {
        node.arguments.description.trimmed
        // Pending update - leaving here for easier reference
        // node.parameters.description.trimmed
    }

    func resolveRawOutput() -> String {
        node.output.returnType.description.trimmed
    }

    func resolveIsOptional() -> Bool {
        // Resolve parent type syntax
        var parentParameter: SyntaxProtocol?
        for case let node? in sequence(first: node.parent, next: { $0?.parent }) {
            if let declaration = node.as(FunctionParameterSyntax.self) {
                parentParameter = declaration
                break
            } else if let declaration = node.as(PatternBindingSyntax.self) {
                parentParameter = declaration
                break
            } else if let declaration = node.as(VariableDeclSyntax.self) {
                parentParameter = declaration
                break
            } else if let declaration = node.as(TupleTypeSyntax.self) {
                parentParameter = declaration
                break
            }
        }
        guard let parentNode = parentParameter else { return false }
        return parentNode.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }

    func resolveIsEscaping() -> Bool {
        var nextParent = node.parent
        while nextParent != nil {
            if let attributed = nextParent?.as(AttributedTypeSyntax.self) {
                let attributes = AttributesCollector.collect(attributed)
                return attributes.contains(where: { $0.name == "escaping" })
            }
            if nextParent?.syntaxNodeType == FunctionTypeSyntax.self {
                break
            }
            nextParent = nextParent?.parent
        }
        return false
    }

    func resolveEffectSpecifiers() -> EffectSpecifiers? {
        guard let specifiers = node.effectSpecifiers else { return nil }
        return EffectSpecifiers(node: specifiers)
    }
}
