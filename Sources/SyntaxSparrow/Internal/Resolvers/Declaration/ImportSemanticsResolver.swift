//
//  ExtensionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `ImportDeclSyntax` node.
/// It exposes the expected properties of a `Import` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct ImportSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = ImportDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: ImportDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    func resolveKeyword() -> String {
         node.importKeyword.text.trimmed
    }

    func resolveModifiers() -> [Modifier] {
        node.modifiers.map { Modifier(node: $0) }
    }

    func resolveKind() -> String? {
        node.importKindSpecifier?.text.trimmed
    }

    func resolvePathComponents() -> [String] {
        let components = node.path.tokens(viewMode: .fixedUp).filter { $0.tokenKind != .period }
        return components.map(\.text.trimmed)
    }
}
