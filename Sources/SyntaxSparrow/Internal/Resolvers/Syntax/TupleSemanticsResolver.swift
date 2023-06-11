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
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class TupleSemanticsResolver: TupleNodeSemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = TupleTypeSyntax

    let node: Node

    private(set) lazy var elements: [Parameter] = resolveElements()

    private(set) lazy var isOptional: Bool = resolveIsOptional()

    // MARK: - Lifecycle

    required init(node: TupleTypeSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveElements() -> [Parameter] {
        node.elements.map(Parameter.init)
    }

    private func resolveIsOptional() -> Bool {
        node.resolveIsOptional(viewMode: .fixedUp)
    }
}
