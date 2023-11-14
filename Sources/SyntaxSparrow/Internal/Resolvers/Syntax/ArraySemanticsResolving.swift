//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

protocol ArraySemanticsResolving: SemanticsResolving {
    func resolveElementType() -> EntityType
    func resolveIsOptional() -> Bool
}

struct ArrayIdentifierSemanticsResolver: ArraySemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = IdentifierTypeSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: IdentifierTypeSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveElementType() -> EntityType {
        guard let typeArg = node.genericArgumentClause?.arguments.first else {
            return .empty
        }
        return EntityType(typeArg.argument)
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }
}

struct ArrayTypeSemanticsResolver: ArraySemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = ArrayTypeSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: ArrayTypeSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveElementType() -> EntityType {
        EntityType(node.element)
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }
}
