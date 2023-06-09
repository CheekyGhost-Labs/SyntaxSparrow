//
//  ClosureSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `NodeSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `TupleTypeSyntax` node.
/// It exposes the expected properties of a `Function` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class ClosureSemanticsResolver: NodeSemanticsResolving {
    // MARK: - Properties: NodeSemanticsResolving

    typealias Node = FunctionTypeSyntax

    let node: Node

    private(set) lazy var input: EntityType = resolveInput()

    private(set) lazy var output: EntityType = resolveOutput()

    private(set) lazy var rawInput: String = resolveRawInput()

    private(set) lazy var rawOutput: String = resolveRawOutput()

    private(set) lazy var isEscaping: Bool = resolveIsEscaping()

    private(set) lazy var isOptional: Bool = resolveIsOptional()

    // MARK: - Lifecycle

    required init(node: FunctionTypeSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op
    }

    // MARK: - Resolvers

    private func resolveInput() -> EntityType {
        guard !node.arguments.isEmpty else { return .void }
        return EntityType.parseElementList(node.arguments)
    }

    private func resolveOutput() -> EntityType {
        EntityType.parseType(node.output.returnType)
    }

    private func resolveRawInput() -> String {
        node.arguments.description.trimmed
    }

    private func resolveRawOutput() -> String {
        node.output.returnType.description.trimmed
    }

    private func resolveIsOptional() -> Bool {
        var nextParent = node.parent
        while nextParent != nil {
            if nextParent?.as(OptionalTypeSyntax.self) != nil {
                return true
            }
            if nextParent?.syntaxNodeType == FunctionTypeSyntax.self {
                break
            }
            nextParent = nextParent?.parent
        }
        if node.children(viewMode: .fixedUp).contains(where: { $0.syntaxNodeType == OptionalTypeSyntax.self }) {
            return true
        }
        return false
    }

    private func resolveIsEscaping() -> Bool {
        var nextParent = node.parent
        while nextParent != nil {
            if let attributed = nextParent?.as(AttributedTypeSyntax.self) {
                let attributes = AttributesCollector.collect(attributed)
                return attributes.contains(where: { $0.name == "escaping" })
            }
            if nextParent?.syntaxNodeType == FunctionTypeSyntax.self {
                break
            }
            nextParent = nextParent?.parent
        }
        return false
    }
}
