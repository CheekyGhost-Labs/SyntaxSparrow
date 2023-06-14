//
//  GenericParameterSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `GenericParameterSyntax` node.
/// It exposes the expected properties of a `GenericParameter` via resolving methods
struct GenericParameterSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = GenericParameterSyntax

    let node: Node

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var type: String? = resolveType()

    // MARK: - Lifecycle

    init(node: GenericParameterSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveType() -> String? {
        node.inheritedType?.description.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }
}
