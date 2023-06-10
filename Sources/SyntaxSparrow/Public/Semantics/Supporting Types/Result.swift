//
//  Result.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift `Result` type.
///
/// In Swift, the `Result` type is used to model the success/failure of an operation. The `Result` struct encapsulates a `Result` type from
/// a Swift source file and provides access to the success and failure types.
///
/// The success and failure types are represented as `EntityType` instances.
/// For example, for the `Result` type `Result<String, Error>`, the success type will be `.simple("String")` and the failure type will be
/// `.simple("Error")`.
///
/// This struct provides functionality to create a `Result` instance from a `SimpleTypeIdentifierSyntax` node. If the `node.firstToken.tokenKind` is
/// not `"Result"`, the initializer will return `nil`.
public struct Result: Hashable, Equatable, CustomStringConvertible {
    // MARK: - Properties

    /// The success type from the `Result`.
    ///
    /// For example, in the type `Result<String, Error>` the type will be `.simple("String")`
    public var successType: EntityType { resolver.successType }

    /// The failure type from the `Result`.
    ///
    /// For example, in the type `Result<String, Error>` the type will be `.simple("Error")`
    public var failureType: EntityType { resolver.failureType }

    /// `Bool` whether the result type is optional.
    ///
    /// For example, `Result<String, Error>?` has `isOptional` as `true`.
    public var isOptional: Bool { resolver.isOptional }

    // MARK: - Properties: Convenience

    var resolver: ResultSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Result`` instance from a `SimpleTypeIdentifierSyntax` node.
    ///
    /// **Note:** Will return `nil` if the `node.firstToken.tokenKind` is not `Result`
    public init?(_ node: SimpleTypeIdentifierSyntax) {
        guard node.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Result") else { return nil }
        resolver = ResultSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: Result, rhs: Result) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        resolver.node.description.trimmed
    }
}
