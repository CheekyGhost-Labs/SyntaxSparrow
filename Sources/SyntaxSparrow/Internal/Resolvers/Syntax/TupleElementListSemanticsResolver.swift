//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `NodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `TupleTypeSyntax`
/// node.
/// It exposes the expected properties of a `Tuple` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed
/// repeatedly.
struct TupleElementListSemanticsResolver: TupleNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TupleTypeElementListSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: TupleTypeElementListSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    func resolveElements() -> [Parameter] {
        node.map(Parameter.init)
    }

    func resolveIsOptional() -> Bool {
        node.resolveIsSyntaxOptional(viewMode: .fixedUp)
    }
}
