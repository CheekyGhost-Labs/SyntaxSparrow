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
        guard parent?.as(OptionalTypeSyntax.self) == nil else { return true }
        var nextParent = parent
        while nextParent != nil {
            if nextParent?.as(OptionalTypeSyntax.self) != nil {
                return true
            }
            if nextParent?.syntaxNodeType == FunctionTypeSyntax.self {
               break
            }
            nextParent = nextParent?.parent
        }
        if children(viewMode: viewMode).contains(where: { $0.syntaxNodeType == OptionalTypeSyntax.self }) {
            return true
        }
        return false
    }
}
