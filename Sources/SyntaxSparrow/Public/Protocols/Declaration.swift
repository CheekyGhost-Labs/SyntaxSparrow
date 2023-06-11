//
//  Declaration.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

/// Public protocol that any public semantic declarations will conform to. A declaration is considered a semantic element that represents items such as struct, protocol, class, enum, etc
public protocol Declaration: SyntaxRepresenting {

    /// Will initialize a new instance that will resolve details from the given node as they are requested.
    /// - Parameters:
    ///   - node: The node to resolve from.
    ///   - context: The ``SyntaxExplorerContext`` instance from the parent `SyntaxTree`. This is used for source location resolving where possible.
    init(node: Syntax, context: SyntaxExplorerContext)
}
