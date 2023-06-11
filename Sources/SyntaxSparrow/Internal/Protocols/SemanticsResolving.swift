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

    /// Will initialize a new declaration instance that will process the given node for properties and child collections.
    /// - Parameters:
    ///   - node: The node to process.
    ///   - context: The explorer context the declaration is being collected within
    init(node: Node)
}

protocol ParameterNodeSemanticsResolving: SemanticsResolving {
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

protocol TupleNodeSemanticsResolving: SemanticsResolving {
    var elements: [Parameter] { get }
    var isOptional: Bool { get }
}
