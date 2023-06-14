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
    func resolveAttributes() -> [Attribute]
    func resolveModifiers() -> [Modifier]
    func resolveName() -> String?
    func resolveSecondName() -> String?
    func resolveType() -> EntityType
    func resolveRawType() -> String
    func resolveIsVariadic() -> Bool
    func resolveIsOptional() -> Bool
    func resolveDefaultArgument() -> String?
    func resolveIsInOut() -> Bool
    func resolveIsLabelOmitted() -> Bool
    func resolveDescription() -> String
}

extension ParameterNodeSemanticsResolving {
    func resolveDescription() -> String {
        let result = node.description.trimmed
        if result.hasSuffix(",") {
            return String(result.dropLast(1))
        }
        return result
    }

    func resolveIsLabelOmitted() -> Bool {
        resolveName() == "_"
    }
}

protocol TupleNodeSemanticsResolving: SemanticsResolving {
    func resolveElements() -> [Parameter]
    func resolveIsOptional() -> Bool
}
