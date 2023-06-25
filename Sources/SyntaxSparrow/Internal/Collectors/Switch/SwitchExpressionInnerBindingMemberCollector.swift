//
//  File.swift
//  
//
//  Created by Michael O'Brien on 25/6/2023.
//

import Foundation
import SwiftSyntax

class SwitchExpressionInnerBindingMemberCollector: SkipByDefaultVisitor {

    struct Binding {
        var keyword: String = ""
        var value: String = ""
    }

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var bindings: [Binding] = []

    private(set) var focusedFunctionNode: FunctionCallExprSyntax?

    private(set) var focusedElementListNode: TupleExprElementListSyntax?

    // MARK: - Helpers

    func collect(_ node: CaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let memberName else { return nil }
        var bindingMap: [String: String] = [:]
        bindings.forEach { bindingMap[$0.keyword] = $0.value }
        return .innerValueBindingMember(name: memberName, elements: bindingMap)
    }

    // MARK: - Overrides

    /// Called when visiting a `VariableDeclSyntax` node
    override func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        guard focusedFunctionNode == nil else { return .skipChildren }
        focusedFunctionNode = node
        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedNode = focusedFunctionNode, node.parent?.id == focusedNode.id else { return .skipChildren }
        memberName = node.name.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: TupleExprElementListSyntax) -> SyntaxVisitorContinueKind {
        guard node.parent?.id == focusedFunctionNode?.id else { return .skipChildren }
        guard focusedElementListNode == nil else { return .skipChildren }
        focusedElementListNode = node
        return .visitChildren
    }

    override func visit(_ node: TupleExprElementSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedElements = focusedElementListNode, node.parent?.id == focusedElements.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: UnresolvedPatternExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedElements = focusedElementListNode, node.parent?.parent?.id == focusedElements.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        let binding = Binding(
            keyword: node.bindingKeyword.text.trimmed,
            value: node.valuePattern.trimmedDescription
        )
        bindings.append(binding)
        return .skipChildren
    }
}
