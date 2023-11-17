//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

protocol DictionarySemanticsResolving: SemanticsResolving {
    func resolveKeyType() -> EntityType
    func resolveElementType() -> EntityType
    func resolveIsOptional() -> Bool
}

struct DictionaryIdentifierSemanticsResolver: DictionarySemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = IdentifierTypeSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: IdentifierTypeSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveKeyType() -> EntityType {
        guard let typeArg = node.genericArgumentClause?.arguments.first else {
            return .empty
        }
        return EntityType(typeArg.argument)
    }

    func resolveElementType() -> EntityType {
        guard let typeArg = node.genericArgumentClause?.arguments.last else {
            return .empty
        }
        return EntityType(typeArg.argument)
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }
}

struct DictionaryTypeSemanticsResolver: DictionarySemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = DictionaryTypeSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: DictionaryTypeSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveKeyType() -> EntityType {
        return EntityType(node.key)
    }

    func resolveElementType() -> EntityType {
        EntityType(node.value)
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }
}
