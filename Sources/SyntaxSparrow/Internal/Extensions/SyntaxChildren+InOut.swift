//
//  SyntaxChildren+InOut.swift
//  
//
//  Created by Michael O'Brien on 20/10/2024.
//

import SwiftSyntax

extension SyntaxChildren {
    
    /// Will assess the children in the current collection and search for inout token kinds with a shallow strategy.
    /// Shallow referring to the child being a direct `TokenSyntax` type or a `TypeSpecifierListSyntax` containing a
    /// child that is a `SimpleTypeSpecifierSyntax` whose token kind is an `inout`
    /// - Returns: `Bool`
    func resolveIsInOut() -> Bool {
        contains(where: {
            // Ignoring experimental `LifetimeTypeSpecifierSyntax` type for now.
            if let specifierListType = $0.as(TypeSpecifierListSyntax.self) {
                let nodes = specifierListType.compactMap { $0.as(SimpleTypeSpecifierSyntax.self) }
                let tokens = nodes.flatMap { $0.tokens(viewMode: .fixedUp) }
                return tokens.contains(where: { $0.tokenKind == TokenKind.keyword(.inout) })
            }
            // returning expected syntax type (if valid)
            return $0.as(TokenSyntax.self)?.tokenKind == TokenKind.keyword(.inout)
        })
    }
}

