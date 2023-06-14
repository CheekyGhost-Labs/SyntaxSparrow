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
struct TupleParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TupleTypeElementSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: TupleTypeElementSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttributes() -> [Attribute] {
        []
    }

    func resolveModifiers() -> [Modifier] {
        []
    }

    func resolveDefaultArgument() -> String? {
        nil
    }

    func resolveName() -> String? {
        node.name?.text.trimmed
    }

    func resolveSecondName() -> String? {
        node.secondName?.text.trimmed
    }

    func resolveRawType() -> String {
        var result = node.type.description.trimmed
        if let ellipsis = node.ellipsis {
            result += ellipsis.text.trimmed
        }
        return result
    }

    func resolveType() -> EntityType {
        return EntityType.parseType(node.type)
    }

    func resolveIsVariadic() -> Bool {
        node.ellipsis != nil
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsOptional(viewMode: .fixedUp)
    }

    func resolveIsInOut() -> Bool {
        node.inOut != nil
    }
}
