//
//  SwitchExpressionMemberCollector.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
import SwiftSyntax

class SwitchExpressionMemberCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var focusedExpressionNode: ExpressionPatternSyntax?

    // MARK: - Helpers

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let memberName else { return nil }
        return .member(name: memberName)
    }

    // MARK: - Overrides

    override func visit(_ node: SwitchCaseItemSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        guard focusedExpressionNode == nil else { return .skipChildren }
        focusedExpressionNode = node
        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedNode = focusedExpressionNode, node.parent?.id == focusedNode.id else { return .skipChildren }
        memberName = node.declName.baseName.text.trimmed
        return .skipChildren
    }
}
