//
//  SyntaxProtocol+IsOptional.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension SyntaxProtocol {

    /// Will asses the current `SyntaxProtocol` node without type context (i.e not `TypeSyntaxProtocol`) and perform a parent based assessment to resolve if
    /// the node is within an `OptionalTypeSyntax`. If there is no parent `OptionalTypeSyntax` (possible in some cases) the `nextToken` will be iterated until
    /// the parent node is exited, or an optional token found.
    /// - Parameter viewMode: The `SyntaxTreeViewMode` to use when parsing children.
    /// - Returns: `Bool`
    func resolveIsSyntaxOptional(viewMode: SyntaxTreeViewMode = .fixedUp) -> Bool {
        guard self.as(OptionalTypeSyntax.self) == nil else { return true }
        guard parent?.as(OptionalTypeSyntax.self) == nil else { return true }
        // Token assessment approach
        var result = false
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
