//
//  AssociatedTypeSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `DeinitializerDeclSyntax` node.
/// It exposes the expected properties of a `Deinitializer` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct DeinitializerSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = DeinitializerDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: DeinitializerDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
        node.deinitKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    func resolveBody() -> CodeBlock? {
        guard let body = node.body else { return nil }
        return CodeBlock(node: body)
    }
}
