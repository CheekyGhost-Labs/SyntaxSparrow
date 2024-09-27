//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public struct EffectSpecifiers: Hashable, Equatable, CustomStringConvertible {
    // MARK: - Properties: DeclarationComponent
    
    /// The `SyntaxProtocol` conforming node being represented.
    ///
    /// This will be one of the following:
    /// - `AccessorEffectSpecifiersSyntax`
    /// - `TypeEffectSpecifiersSyntax`
    /// - `FunctionEffectSpecifiersSyntax`
    ///
    /// you can cast this to a supported type if you need direct access by using the `as()` helper.
    /// i.e
    /// ```swift
    /// instance.node.as(AccessorEffectSpecifiersSyntax.self)
    /// ```
    public let node: SyntaxProtocol

    // MARK: - Properties

    /// The `throws` keyword, if any.
    /// Indicates whether the function can throw an error.
    public let throwsSpecifier: String?

    /// The `asyncSpecifier` specifier, if any.
    /// Indicates whether the function supports structured concurrency.
    public let asyncSpecifier: String?

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/EffectSpecifiers`` instance from an `AccessorEffectSpecifiersSyntax` node.
    public init(node: AccessorEffectSpecifiersSyntax) {
        self.node = node
        throwsSpecifier = node.throwsSpecifier?.text.trimmed
        asyncSpecifier = node.asyncSpecifier?.text.trimmed
    }

    /// Creates a new ``SyntaxSparrow/EffectSpecifiers`` instance from an `TypeEffectSpecifiersSyntax` node.
    public init(node: TypeEffectSpecifiersSyntax) {
        self.node = node
        throwsSpecifier = node.throwsSpecifier?.text.trimmed
        asyncSpecifier = node.asyncSpecifier?.text.trimmed
    }

    /// Creates a new ``SyntaxSparrow/EffectSpecifiers`` instance from an `FunctionEffectSpecifiersSyntax` node.
    public init(node: FunctionEffectSpecifiersSyntax) {
        self.node = node
        throwsSpecifier = node.throwsSpecifier?.text.trimmed
        asyncSpecifier = node.asyncSpecifier?.text.trimmed
    }

    // MARK: - Equatable

    public static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        node.description.trimmed
    }
}
