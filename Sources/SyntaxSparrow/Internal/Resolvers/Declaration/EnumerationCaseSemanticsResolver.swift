//
//  EnumerationCaseSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a `EnumCaseElementSyntax` node.
/// It exposes the expected properties of a `Enumeration.Case` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when accessed repeatedly.
class EnumerationCaseSemanticsResolver: DeclarationSemanticsResolving {
    // MARK: - Properties: DeclarationSemanticsResolving

    typealias Node = EnumCaseElementSyntax

    let node: Node

    let context: SyntaxExplorerContext

    private(set) var declarationCollection: DeclarationCollection = .init()

    private(set) lazy var sourceLocation: SyntaxSourceLocation = resolveSourceLocation()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var attributes: [Attribute] = resolveAttributes()

    private(set) lazy var modifiers: [Modifier] = resolveModifiers()

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var rawValue: String? = resolveRawValue()

    private(set) lazy var associatedValues: [Parameter]? = resolveAssociatedValues()

    // TODO: Parameters

    // MARK: - Lifecycle

    required init(node: EnumCaseElementSyntax, context: SyntaxExplorerContext) {
        self.node = node
        self.context = context
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

    private func resolveName() -> String {
        node.identifier.text.trimmed
    }

    private func resolveAttributes() -> [Attribute] {
        withParent { Attribute.fromAttributeList($0.attributes) } ?? []
    }

    private func resolveKeyword() -> String {
        withParent { $0.caseKeyword.text.trimmed } ?? ""
    }

    private func resolveModifiers() -> [Modifier] {
        withParent {
            $0.modifiers?.map { Modifier($0) } ?? []
        } ?? []
    }

    private func resolveRawValue() -> String? {
        node.rawValue?.value.description.trimmed
    }

    private func resolveAssociatedValues() -> [Parameter]? {
        guard let associatedValue = node.associatedValue else { return nil }
        return associatedValue.parameterList.map {
            Parameter($0)
        }
    }
}
