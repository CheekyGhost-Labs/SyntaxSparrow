//
//  File.swift
//  
//
//  Created by Michael O'Brien on 23/5/2023.
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
