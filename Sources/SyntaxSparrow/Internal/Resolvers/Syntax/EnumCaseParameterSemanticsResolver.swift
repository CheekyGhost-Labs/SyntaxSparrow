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
/// It exposes the expected properties of a `FunctionParameter` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated
/// when accessed repeatedly.
class EnumCaseParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = EnumCaseParameterSyntax

    let node: Node

    // MARK: - Properties: ParameterNodeSemanticsResolving

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var name: String? = resolveName()

    private(set) lazy var secondName: String? = resolveSecondName()

    private(set) lazy var type: EntityType = resolveEntityType()

    private(set) lazy var rawType: String? = resolveRawType()

    private(set) lazy var isVariadic: Bool = resolveIsVariadic()

    private(set) lazy var isOptional: Bool = resolveIsOptional()

    private(set) lazy var defaultArgument: String? = resolveDefaultArgument()

    private(set) lazy var isInOut: Bool = resolveIsInout()

    var isLabelOmitted: Bool { name == "_" }

    // MARK: - Lifecycle

    required init(node: EnumCaseParameterSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveAttributes() -> [Attribute] {
        AttributesCollector.collect(node)
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveName() -> String? {
        node.firstName?.text.trimmed
    }

    private func resolveSecondName() -> String? {
        node.secondName?.text.trimmed
    }

    private func resolveRawType() -> String {
        var result = node.type.description.trimmed
        if isVariadic {
            result += "..."
        }
        return result
    }

    private func resolveEntityType() -> EntityType {
        return EntityType.parseType(node.type)
    }

    private func resolveIsVariadic() -> Bool {
        guard
            let parent = node.parent?.parent?.as(EnumCaseParameterClauseSyntax.self),
            let unexpectedToken = parent.unexpectedBetweenParameterListAndRightParen,
            let tokenChild = unexpectedToken.children(viewMode: .fixedUp).first?.as(TokenSyntax.self)
        else {
            return false
        }
        return tokenChild.tokenKind == .postfixOperator("...")
    }

    private func resolveIsOptional() -> Bool {
        false
    }

    private func resolveDefaultArgument() -> String? {
        node.defaultArgument?.value.description.trimmed
    }

    private func resolveIsInout() -> Bool {
        node.type.tokens(viewMode: .fixedUp).contains(where: {
            $0.tokenKind == TokenKind.keyword(.inout)
        })
    }
}
