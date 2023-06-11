//
//  DeclarationSemanticsResolving.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

protocol SemanticsResolving {
    associatedtype Node: SyntaxProtocol

    /// The node being processed.
    var node: Node { get }
}

protocol DeclarationSemanticsResolving: SemanticsResolving, SyntaxSourceLocationResolving {
    /// `SyntaxExplorerContext` instance holding root collection details and instances.
    /// This context will be shared with any child elements that require lazy evaluation or collection as needed.
    var context: SyntaxExplorerContext { get }

    /// Will initialize a new declaration instance that will process the given node for properties and child collections.
    /// - Parameters:
    ///   - node: The node to process.
    ///   - context: The explorer context the declaration is being collected within
    init(node: Node, context: SyntaxExplorerContext)
}

protocol NodeSemanticsResolving: SemanticsResolving {
    /// Will initialize a new declaration instance that will process the given node for properties and child collections.
    /// - Parameter node: The node to process.
    init(node: Node)
}

protocol ParameterNodeSemanticsResolving: NodeSemanticsResolving {
    var attributes: [Attribute] { get }
    var modifiers: [Modifier] { get }
    var name: String? { get }
    var secondName: String? { get }
    var type: EntityType { get }
    var rawType: String? { get }
    var isVariadic: Bool { get }
    var isOptional: Bool { get }
    var defaultArgument: String? { get }
    var isInOut: Bool { get }
    var isLabelOmitted: Bool { get }
    var description: String { get }
}

extension ParameterNodeSemanticsResolving {
    var description: String {
        let result = node.description.trimmed
        if result.hasSuffix(",") {
            return String(result.dropLast(1))
        }
        return result
    }
}

protocol TupleNodeSemanticsResolving: NodeSemanticsResolving {
    var elements: [Parameter] { get }
    var isOptional: Bool { get }
}

// MARK: - Common Location Properties and Helpers

extension DeclarationSemanticsResolving {
    func resolveSourceLocation() -> SyntaxSourceLocation {
        if context.sourceLocationConverter.isEmpty {
            context.sourceLocationConverter.updateToRootForNode(node)
        }
        let start = context.sourceLocationConverter.startLocationForNode(node)
        let end = context.sourceLocationConverter.endLocationForNode(node)
        return SyntaxSourceLocation(start: start, end: end)
    }
}
