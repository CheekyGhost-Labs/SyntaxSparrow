//
//  SwitchExpressionCaseSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

struct SwitchExpressionCaseSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = SwitchCaseSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: SwitchCaseSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveAttribute() -> Attribute? {
        guard let attribute = node.attribute else { return nil }
        return Attribute(node: attribute)
    }

    func resolveLabel() -> SwitchExpression.SwitchCase.Label {
        switch node.label {
        case .`default`:
            return .`default`
        case .`case`:
            return .`case`
        }
    }

    func resolveItems() -> [SwitchExpression.SwitchCase.Item] {
        switch node.label {
        case .`default`:
            return []
        case .`case`(let syntax):
            return syntax.caseItems.map {
                SwitchExpression.SwitchCase.Item($0)
            }
        }
    }

    func rsolveStatements() -> [CodeBlock.Statement] {
        node.statements.map { CodeBlock.Statement(node: $0)}
    }
}
