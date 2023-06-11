//
//  SyntaxProtocol+IsOptional.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension SyntaxProtocol {
    func resolveIsOptional(viewMode: SyntaxTreeViewMode = .fixedUp) -> Bool {
        guard self.as(OptionalTypeSyntax.self) == nil else { return true }
        guard parent?.as(OptionalTypeSyntax.self) == nil else { return true }
        // Token assessment approach
        var result: Bool = false
        var nextToken = nextToken(viewMode: .fixedUp)
        var potentialOptional: Bool = nextToken?.text == "?"
        while nextToken != nil {
            if nextToken?.text == ")" {
                potentialOptional = true
            }
            if potentialOptional, nextToken?.text == ")" {
                break
            }
            if potentialOptional, nextToken?.text == "?" {
                result = true
                break
            }
            nextToken = nextToken?.nextToken(viewMode: .fixedUp)
        }
        // Fallback child approach
        if !result, children(viewMode: viewMode).contains(where: { $0.syntaxNodeType == OptionalTypeSyntax.self }) {
            return true
        }
        return result
    }
}
