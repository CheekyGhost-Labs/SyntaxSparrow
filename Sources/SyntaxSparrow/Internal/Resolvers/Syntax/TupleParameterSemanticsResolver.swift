//
//  FunctionParameterSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `ParameterNodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting
/// children of a `TupleTypeElementSyntax` node.
/// It exposes the expected properties of a `Tuple` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed
/// repeatedly.
class TupleParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TupleTypeElementSyntax

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

    private(set) lazy var isInOut: Bool = resolveIsInout()

    let defaultArgument: String? = nil

    var isLabelOmitted: Bool { name == "_" }

    // MARK: - Lifecycle

    required init(node: TupleTypeElementSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveAttributes() -> [Attribute] {
        []
    }

    private func resolveModifiers() -> [Modifier] {
        []
    }

    private func resolveName() -> String? {
        node.name?.text.trimmed
    }

    private func resolveSecondName() -> String? {
        node.secondName?.text.trimmed
    }

    private func resolveRawType() -> String? {
        var result = node.type.description.trimmed
        if let ellipsis = node.ellipsis {
            result += ellipsis.text.trimmed
        }
        return result
    }

    private func resolveEntityType() -> EntityType {
        return EntityType.parseType(node.type)
    }

    private func resolveIsVariadic() -> Bool {
        node.ellipsis != nil
    }

    private func resolveIsOptional() -> Bool {
        node.resolveIsOptional(viewMode: .fixedUp)
    }

    private func resolveIsInout() -> Bool {
        node.inOut != nil
    }
}
