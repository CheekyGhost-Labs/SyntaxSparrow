//
//  File.swift
//  
//
//  Created by Michael O'Brien on 10/6/2023.
//

import Foundation
import SwiftSyntax

public protocol SyntaxRepresenting: Equatable, Hashable, CustomStringConvertible {
    associatedtype Syntax: SyntaxProtocol

    /// The raw syntax node being represented by the instance.
    var node: Syntax { get }
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
