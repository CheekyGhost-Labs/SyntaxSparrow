//
//  FunctionParameterSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `NodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `FunctionParameterSyntax` node.
/// It exposes the expected properties of a `FunctionParameter` via resolving methods
struct EnumCaseParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = EnumCaseParameterSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: EnumCaseParameterSyntax) {
        self.node = node
    }

    // MARK: - Conformance: ParameterNodeSemanticsResolving

    func resolveAttributes() -> [Attribute] {
        AttributesCollector.collect(node)
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveName() -> String? {
        node.firstName?.text.trimmed
    }

    func resolveSecondName() -> String? {
        node.secondName?.text.trimmed
    }

    func resolveRawType() -> String {
        var result = node.type.description.trimmed
        if resolveIsVariadic() {
            result += "..."
        }
        return result
    }

    func resolveType() -> EntityType {
        return EntityType.parseType(node.type)
    }

    func resolveIsVariadic() -> Bool {
        guard
            let parent = node.parent?.parent?.as(EnumCaseParameterClauseSyntax.self),
            let unexpectedToken = parent.unexpectedBetweenParameterListAndRightParen,
            let tokenChild = unexpectedToken.children(viewMode: .fixedUp).first?.as(TokenSyntax.self)
        else {
            return false
        }
        return tokenChild.tokenKind == .postfixOperator("...")
    }

    func resolveIsOptional() -> Bool {
        return node.type.resolveIsOptional()
    }

    func resolveDefaultArgument() -> String? {
        node.defaultArgument?.value.description.trimmed
    }

    func resolveIsInOut() -> Bool {
        node.type.tokens(viewMode: .fixedUp).contains(where: {
            $0.tokenKind == TokenKind.keyword(.inout)
        })
    }

    func resolveDescription() -> String {
        var result = node.description.trimmed
        if result.hasSuffix(",") {
            result = String(result.dropLast(1))
        }
        if resolveIsVariadic() {
            result += "..."
        }
        return result.trimmed
    }
}
