//
//  AttributesCollector.swift
//  
//
//  Created by Michael O'Brien on 23/5/2023.
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

    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: EnumCasePatternSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: FunctionParameterSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: TupleTypeElementSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: AttributedTypeSyntax) -> SyntaxVisitorContinueKind {
        return attributes != nil ? .skipChildren : .visitChildren
    }

    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
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
