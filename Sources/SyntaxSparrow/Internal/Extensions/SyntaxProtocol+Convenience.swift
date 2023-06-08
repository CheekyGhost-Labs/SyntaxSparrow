//
//  SyntaxProtocol+Convenience.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension SyntaxProtocol {
    /// Will return the parent syntax context if it exists.
    var context: DeclSyntaxProtocol? {
        for case let node? in sequence(first: parent, next: { $0?.parent }) {
            guard let declaration = node.asProtocol(DeclSyntaxProtocol.self) else { continue }
            return declaration
        }
        return nil
    }
}
