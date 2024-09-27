//
//  SwitchExpressionInnerBindingMemberCollector.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
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

    private(set) var focusedElementListNode: LabeledExprListSyntax?

    // MARK: - Helpers

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let memberName else { return nil }
        var bindingMap: [String: String] = [:]
        bindings.forEach { bindingMap[$0.keyword] = $0.value }
        return .innerValueBindingMember(name: memberName, elements: bindingMap)
    }

    // MARK: - Overrides

    override func visit(_ node: SwitchCaseItemSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

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
        memberName = node.declName.baseName.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: LabeledExprListSyntax) -> SyntaxVisitorContinueKind {
        guard node.parent?.id == focusedFunctionNode?.id else { return .skipChildren }
        guard focusedElementListNode == nil else { return .skipChildren }
        focusedElementListNode = node
        return .visitChildren
    }

    override func visit(_ node: LabeledExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedElements = focusedElementListNode, node.parent?.id == focusedElements.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: PatternExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedElements = focusedElementListNode, node.parent?.parent?.id == focusedElements.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        let binding = Binding(
            keyword: node.bindingSpecifier.text.trimmed,
            value: node.pattern.trimmedDescription
        )
        bindings.append(binding)
        return .skipChildren
    }
}
