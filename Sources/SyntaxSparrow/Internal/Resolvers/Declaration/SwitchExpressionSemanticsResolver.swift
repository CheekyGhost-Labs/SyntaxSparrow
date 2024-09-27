//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

struct SwitchExpressionSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = SwitchExprSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: SwitchExprSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveKeyword() -> String {
        node.switchKeyword.text.trimmed
    }

    func resolveExpression() -> SwitchExpression.ExpressionIdentifier {
        SwitchExpression.ExpressionIdentifier(node.subject)
    }

    func resolveCases() -> [SwitchExpression.Case] {
        node.cases.map {
            switch $0 {
            case .switchCase(let caseDecl):
                let object = SwitchExpression.SwitchCase(node: caseDecl)
                return .switchCase(object)
            case .ifConfigDecl(let configDecl):
                let object = ConditionalCompilationBlock(node: configDecl)
                return .ifConfig(object)
            }
        }
    }
}
