//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

struct SetSemanticsResolver: SemanticsResolving {

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
