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
class FunctionParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = FunctionParameterSyntax

    let node: Node

    // MARK: - Properties: ParameterNodeSemanticsResolving

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

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

    required init(node: FunctionParameterSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveAttributes() -> [Attribute] {
        AttributesCollector.collect(node)
    }

    private func resolveName() -> String {
        node.firstName.text.trimmed
    }

    private func resolveSecondName() -> String? {
        node.secondName?.text.trimmed
    }

    private func resolveRawType() -> String {
        node.type.description.trimmed
    }

    private func resolveEntityType() -> EntityType {
        return EntityType.parseType(node.type)
    }

    private func resolveIsVariadic() -> Bool {
        node.ellipsis != nil
    }

    private func resolveIsOptional() -> Bool {
        node.resolveIsOptional()
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
