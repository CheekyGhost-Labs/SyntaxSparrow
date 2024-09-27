//
//  SwitchExpressionValueBindingCollector.swift
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

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let keyword, memberName == nil else { return nil }
        return .valueBinding(keyWord: keyword, elements: sequenceElements)
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

    override func visit(_ node: MemberAccessExprSyntax) -> SyntaxVisitorContinueKind {
        // This is a fallback as there should be no member syntax. If there is the result will return nil.
        memberName = node.declName.baseName.text.trimmed
        return .skipChildren
    }

    override func visit(_ node: SequenceExprSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: ExprListSyntax) -> SyntaxVisitorContinueKind {
        sequenceElements = node.map(\.trimmedDescription)
        return .skipChildren
    }

    /*
     Initially listened for the variants I could derive from token exploration. However, as it always
     ends up adding the `node.trimmedDescription`, and there is always an `ExprListSyntax` element that
     contains them, the `ExprListSyntax` visitor override will just map the trimmed description value
     into the sequence. Leaving these in as reference for future refactor/clean-up.
     */

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
