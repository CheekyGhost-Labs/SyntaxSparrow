//
//  EnumerationCaseSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `EnumCaseElementSyntax` node.
/// It exposes the expected properties of a `Enumeration.Case` via resolving methods
struct EnumerationCaseSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = EnumCaseElementSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: EnumCaseElementSyntax) {
        self.node = node
    }

    func collectChildren() {
        // no-op log?
    }

    // MARK: - Resolvers

    private func withParent<T>(_ handler: (EnumCaseDeclSyntax) -> T) -> T? {
        guard let parent = node.context as? EnumCaseDeclSyntax else {
            assertionFailure("EnumCaseElement should be contained within EnumCaseDecl")
            return nil
        }
        return handler(parent)
    }

    func resolveName() -> String {
        node.name.text.trimmed
    }

    func resolveAttributes() -> [Attribute] {
        withParent { Attribute.fromAttributeList($0.attributes) } ?? []
    }

    func resolveKeyword() -> String {
        withParent { $0.caseKeyword.text.trimmed } ?? ""
    }

    func resolveModifiers() -> [Modifier] {
        withParent {
            $0.modifiers.map { Modifier(node: $0) }
        } ?? []
    }

    func resolveRawValue() -> String? {
        node.rawValue?.value.description.trimmed
    }

    func resolveAssociatedValues() -> [Parameter] {
        guard let associatedValue = node.parameterClause else { return [] }
        return associatedValue.parameters.map {
            Parameter(node: $0)
        }
    }
}
