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
    
    /// Will iterate through the node parents in sequence the first parent that returns a non-nil result from the given handler.
    ///
    /// **Note:** As the `SyntaxProtocol` and `Syntax` types are not class based we can't cast easily here. You should
    /// re-cast your result using the `SyntaxProtocol.as(<SyntaxType>.self)`
    /// - Parameter handler: The handler to invoke on parents
    /// - Returns: `SyntaxProtocol` or `nil`
    func firstParent(returning handler: (SyntaxProtocol) -> SyntaxProtocol?) -> SyntaxProtocol? {
        if let current = handler(_syntaxNode) {
            return current
        }
        for case let node? in sequence(first: parent, next: { $0?.parent }) {
            if let resolved = handler(node) {
                return resolved
            }
        }
        return nil
    }
}
