//
//  ExtensionSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `ImportDeclSyntax` node.
/// It exposes the expected properties of a `Import` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class ImportSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = ImportDeclSyntax

    let node: Node

    private(set) var declarationCollection: DeclarationCollection = .init()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var kind: String? = resolveKind()

    private(set) lazy var pathComponents: [String] = resolvePathComponents()

    // MARK: - Lifecycle

    required init(node: ImportDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveAttributes() -> [Attribute] {
        Attribute.fromAttributeList(node.attributes)
    }

    private func resolveKeyword() -> String {
        node.importTok.text.trimmed
        // Pending update - leaving here for easier reference
        // node.importKeyword.text.trimmed
    }

    private func resolveModifiers() -> [Modifier] {
        guard let modifierList = node.modifiers else { return [] }
        return modifierList.map { Modifier(node: $0) }
    }

    private func resolveKind() -> String? {
        node.importKind?.text.trimmed
    }

    private func resolvePathComponents() -> [String] {
        let components = node.path.tokens(viewMode: .fixedUp).filter { $0.tokenKind != .period }
        return components.map(\.text.trimmed)
    }
}
