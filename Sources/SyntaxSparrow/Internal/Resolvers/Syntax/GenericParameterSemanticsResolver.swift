//
//  GenericParameterSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `GenericParameterSyntax` node.
/// It exposes the expected properties of a `GenericParameter` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated
/// when accessed repeatedly.
class GenericParameterSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = GenericParameterSyntax

    let node: Node

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var type: String? = resolveType()

    // MARK: - Lifecycle

    required init(node: GenericParameterSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveName() -> String {
        node.name.text.trimmed
    }

    private func resolveType() -> String? {
        node.inheritedType?.description.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }
}
