//
//  FunctionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `OperatorDeclSyntax` node.
/// It exposes the expected properties of a `Operator` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct OperatorSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = OperatorDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: OperatorDeclSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveKeyword() -> String {
        node.operatorKeyword.text.trimmed
    }

    func resolveKind() -> Operator.Kind? {
        Operator.Kind(node.fixitySpecifier)
    }
}
