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
struct FunctionParameterSemanticsResolver: ParameterNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = FunctionParameterSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: FunctionParameterSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttributes() -> [Attribute] {
        AttributesCollector.collect(node)
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveName() -> String? {
        node.firstName.text.trimmed
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
        return EntityType(node.type)
    }

    func resolveIsVariadic() -> Bool {
        node.ellipsis != nil
    }

    func resolveIsOptional() -> Bool {
        node.type.resolveIsSyntaxOptional()
    }

    func resolveDefaultArgument() -> String? {
        node.defaultValue?.value.description.trimmed
    }

    func resolveIsInOut() -> Bool {
        node.type.children(viewMode: .fixedUp).resolveIsInOut()
    }
}
