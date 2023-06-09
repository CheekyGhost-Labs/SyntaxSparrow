//
//  SyntaxProtocol+Convenience.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension SyntaxProtocol {

    /// Will return the parent `DeclSyntaxProtocol` token if it exists.
    var context: DeclSyntaxProtocol? {
        if let current = _syntaxNode.asProtocol(DeclSyntaxProtocol.self) {
            return current
        }
        for case let node? in sequence(first: parent, next: { $0?.parent }) {
            guard let declaration = node.asProtocol(DeclSyntaxProtocol.self) else { continue }
            return declaration
        }
        return nil
    }
}
