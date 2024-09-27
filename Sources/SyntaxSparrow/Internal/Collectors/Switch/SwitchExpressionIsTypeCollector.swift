//
//  SwitchExpressionValueBindingCollector.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
import SwiftSyntax

class SwitchExpressionIsTypeCollector: SkipByDefaultVisitor {

    // MARK: - Properties

    private(set) var type: String?

    // MARK: - Helpers

    func collect(_ node: SwitchCaseItemSyntax) -> SwitchExpression.SwitchCase.Item? {
        walk(node)
        guard let type else { return nil }
        return .isTypePattern(type: type)
    }

    // MARK: - Overrides

    override func visit(_ node: SwitchCaseItemSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: IsTypePatternSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: IdentifierTypeSyntax) -> SyntaxVisitorContinueKind {
        type = node.description
        return .skipChildren
    }
}
