//
//  SwitchExpressionValueBindingMemberCollector.swift
//  
//
//  Created by Michael O'Brien on 25/6/2023.
//

import Foundation
import SwiftSyntax

class SwitchExpressionValueBindingMemberCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var keyword: String?

    private(set) var bindings: [String] = []

    private(set) var focusedBindingNode: ValueBindingPatternSyntax?

    private(set) var focusedFunctionNode: FunctionCallExprSyntax?

    // MARK: - Helpers

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let keyword, let memberName else { return nil }
        return .valueBindingMember(keyWord: keyword, name: memberName, elements: bindings)
    }

    // MARK: - Overrides

    override func visit(_ node: SwitchCaseItemSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        guard focusedBindingNode == nil else { return .skipChildren }
        focusedBindingNode = node
        keyword = node.bindingSpecifier.trimmedDescription
        return .visitChildren
    }

    override func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedNode = focusedBindingNode, node.parent?.id == focusedNode.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: FunctionCallExprSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        memberName = node.declName.baseName.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: LabeledExprListSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: LabeledExprSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: PatternExprSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
        bindings.append(node.identifier.trimmedDescription)
        return .skipChildren
    }
}
