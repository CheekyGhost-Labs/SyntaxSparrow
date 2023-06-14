//
//  File.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public protocol SyntaxRepresenting: Equatable, Hashable, CustomStringConvertible {
    associatedtype Syntax: SyntaxProtocol

    /// The raw syntax node being represented by the instance.
    var node: Syntax { get }

    /// Will initialize a new instance that will resolve details from the given node as they are requested.
    /// - Parameter node: The node to resolve from.
    init(node: Syntax)
}

// MARK: - Equatable/Hashable/CustomStringConvertible

public extension SyntaxRepresenting {
    // MARK: - Equatable

    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    var description: String {
        node.description.trimmed
    }
}
