//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension TypeSyntaxProtocol {
    
    /// Will asses the current `TypeSyntaxProtocol` node and return `true` if it is an optional type.
    /// - Parameter viewMode: The `SyntaxTreeViewMode` to use when parsing children.
    /// - Returns: `Bool`
    func resolveIsTypeOptional(viewMode: SyntaxTreeViewMode = .fixedUp) -> Bool {
        let softCheck = parent?.description.trimmed.hasSuffix("?") ?? false
        guard !softCheck else { return true }
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
        return result
    }
}
