//
//  AttributeSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `AttributeSyntax` node.
/// It exposes the expected properties of a `Attribute` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class AttributeSemanticsResolver: NodeSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = AttributeSyntax

    let node: Node

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var name: String = resolveName()

    private(set) lazy var arguments: [Attribute.Argument] = resolveArguments()

    // MARK: - Lifecycle

    required init(node: AttributeSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveName() -> String {
        node.attributeName.description.trimmed
    }

    private func resolveArguments() -> [Attribute.Argument] {
        guard let argumentNode = node.argument else { return [] }
        // Can ultimately switch here for more accuracy and support for specialized types. For now just getting name:value pairs
        let components = argumentNode.description.split(separator: ",")
        let pairs = components.compactMap {
            let entry = $0.split(separator: ":", maxSplits: 1)
            switch entry.count {
            case 2:
                return Attribute.Argument(name: String(entry[0]), value: String(entry[1]))
            case 1:
                return Attribute.Argument(name: nil, value: String(entry[0]))
            default:
                assertionFailure("invalid argument token: \($0)")
                return nil
            }
        }
        return pairs
    }
}
