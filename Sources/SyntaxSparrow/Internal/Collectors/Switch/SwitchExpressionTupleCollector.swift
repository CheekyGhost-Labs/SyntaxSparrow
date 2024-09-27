//
//  SwitchExpressionTupleCollector.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
import SwiftSyntax

class SwitchExpressionTupleCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var elements: [String]?

    private(set) var focusedExpressionNode: ExpressionPatternSyntax?

    // MARK: - Helpers

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let elements, memberName == nil else { return nil }
        return .tuple(elements: elements)
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
        // This is a fallback as there should be no member syntax. If there is the result will return nil.
        memberName = node.declName.baseName.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: TupleExprSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedExpressionNode, node.parent?.id == focusedExpressionNode.id, elements == nil else { return .skipChildren }
        elements = node.elements.trimmedDescription.components(separatedBy: ",").map(\.trimmed)
        return .skipChildren
    }
}
