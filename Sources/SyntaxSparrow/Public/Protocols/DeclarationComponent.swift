//
//  File.swift
//  
//
//  Created by Michael O'Brien on 10/6/2023.
//

import Foundation

/// Public protocol that any semantic elements not considered a declaration will conform to.
/// A declaration component is considered a semantic element that supports or decorates a declaration such as attributes, modifiers, generic parameter/requirement, parameters, etc
public protocol DeclarationComponent: SyntaxRepresenting {

    /// Will initialize a new instance that will resolve details from the given node as they are requested.
    /// - Parameters node: The node to resolve from.
    init(node: Syntax)
}
