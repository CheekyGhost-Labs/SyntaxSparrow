//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `NodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `GenericArgumentListSyntax` node.
/// It exposes the expected properties of a `Result` type as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
/// The `GenericArgumentListSyntax` is resolved from a `SimpleTypeIdentifierSyntax`.
struct ResultSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = SimpleTypeIdentifierSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: SimpleTypeIdentifierSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }

    func resolveSuccessType() -> EntityType {
        guard
            let arguments = node.genericArgumentClause?.arguments,
            arguments.count == 2,
            let successType = arguments.first
        else {
            return .empty
        }
        return EntityType(successType.argumentType)
    }

    func resolveFailureType() -> EntityType {
        guard
            let arguments = node.genericArgumentClause?.arguments,
            arguments.count == 2,
            let failureType = arguments.last
        else {
            return .empty
        }
        return EntityType(failureType.argumentType)
    }
}
