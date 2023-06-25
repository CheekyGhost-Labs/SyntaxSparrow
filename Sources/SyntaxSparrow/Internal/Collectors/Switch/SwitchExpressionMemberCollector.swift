//
//  File.swift
//  
//
//  Created by Michael O'Brien on 25/6/2023.
//

import Foundation
import SwiftSyntax

class SwitchExpressionMemberCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var focusedExpressionNode: ExpressionPatternSyntax?

    // MARK: - Helpers

    func collect(_ node: CaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let memberName else { return nil }
        return .member(name: memberName)
    }

    // MARK: - Overrides

    /// Called when visiting a `VariableDeclSyntax` node
    override func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        guard focusedExpressionNode == nil else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedNode = focusedExpressionNode, node.parent?.id == focusedNode.id else { return .skipChildren }
        memberName = node.name.text.trimmed
        return .skipChildren
    }
}
