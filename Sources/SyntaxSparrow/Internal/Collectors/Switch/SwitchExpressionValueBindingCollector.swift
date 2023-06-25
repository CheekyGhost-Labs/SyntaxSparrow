//
//  File.swift
//  
//
//  Created by Michael O'Brien on 25/6/2023.
//

import Foundation
import SwiftSyntax

class SwitchExpressionValueBindingCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var memberName: String?

    private(set) var keyword: String?

    private(set) var sequenceElements: [String] = []

    private(set) var focusedBindingNode: ValueBindingPatternSyntax?

    private(set) var focusedFunctionNode: FunctionCallExprSyntax?

    // MARK: - Helpers

    func collect(_ node: CaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let keyword, memberName == nil else { return nil }
        return .valueBinding(keyWord: keyword, elements: sequenceElements)
    }

    // MARK: - Overrides

    override func visit(_ node: ValueBindingPatternSyntax) -> SyntaxVisitorContinueKind {
        guard focusedBindingNode == nil else { return .skipChildren }
        focusedBindingNode = node
        keyword = node.bindingKeyword.trimmedDescription
        return .visitChildren
    }

    override func visit(_ node: ExpressionPatternSyntax) -> SyntaxVisitorContinueKind {
        guard let focusedNode = focusedBindingNode, node.parent?.id == focusedNode.id else { return .skipChildren }
        return .visitChildren
    }

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        // This is a fallback as there should be no member syntax. If there is the result will return nil.
        memberName = node.name.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: ExprListSyntax) -> SyntaxVisitorContinueKind {
        sequenceElements = node.map { $0.trimmedDescription }
        return .visitChildren
    }

//    override func visit(_ node: UnresolvedPatternExprSyntax) -> SyntaxVisitorContinueKind {
//        return .visitChildren
//    }
//
//    override func visit(_ node: TypeExprSyntax) -> SyntaxVisitorContinueKind {
//        sequenceElements.append(node.trimmedDescription)
//        return .skipChildren
//    }
//
//    override func visit(_ node: UnresolvedAsExprSyntax) -> SyntaxVisitorContinueKind {
//        sequenceElements.append(node.trimmedDescription)
//        return .skipChildren
//    }
//
//    override func visit(_ node: UnresolvedIsExprSyntax) -> SyntaxVisitorContinueKind {
//        sequenceElements.append(node.trimmedDescription)
//        return .skipChildren
//    }
//
//    override func visit(_ node: IdentifierPatternSyntax) -> SyntaxVisitorContinueKind {
//        sequenceElements.append(node.identifier.trimmedDescription)
//        return .skipChildren
//    }
}
