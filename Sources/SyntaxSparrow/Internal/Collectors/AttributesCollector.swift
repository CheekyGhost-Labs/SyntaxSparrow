//
//  AttributesCollector.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

class AttributesCollector: SkipByDefaultVisitor {
    // MARK: - Convenience

    static func collect(_ node: SyntaxProtocol) -> [Attribute] {
        let collector = AttributesCollector(viewMode: .fixedUp)
        collector.walk(node)
        return collector.attributes ?? []
    }

    // MARK: - Properties

    var attributes: [Attribute]?

    // MARK: - Overrides

    override func visit(_: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: TupleTypeElementSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: AttributedTypeSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: AttributeListSyntax) -> SyntaxVisitorContinueKind {
        let attribtueSyntaxes = node.children(viewMode: .fixedUp).compactMap { $0.as(AttributeSyntax.self) }
        attributes = attribtueSyntaxes.map { Attribute(node: $0) }
        return .skipChildren
    }

    override func visit(_ node: AttributeSyntax) -> SyntaxVisitorContinueKind {
        attributes = [Attribute(node: node)]
        return .skipChildren
    }
}
