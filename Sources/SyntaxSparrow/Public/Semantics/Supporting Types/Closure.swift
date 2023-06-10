//
//  Closure.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift closure expression.
///
/// A closure is a self-contained block of functionality that can be passed around and used in your code. In Swift, closures are similar to blocks in
/// C and Objective-C and
/// to lambdas in other programming languages.
///
/// An instance of the `Closure` struct provides access to:
/// - The input and output types of the closure.
/// - Whether the closure's input or output type is void.
/// - Whether the closure is optional.
/// - Whether the closure has the `@escaping` attribute or is auto-escaping.
///
/// This struct also includes functionality to create a closure instance from a `FunctionTypeSyntax` node.
public struct Closure: Hashable, Equatable, CustomStringConvertible {
    /// Will return the closure input element from the input `typeAnnotation` for the closure.
    var input: EntityType { resolver.input }

    /// Will return the input string for the closure. Returns an empty string if no result is found.
    var rawInput: String { resolver.rawInput }

    /// Will return the closure output elements from the input `typeAnnotation` for the closure.
    var output: EntityType { resolver.output }

    /// Will return the return type string for the closure. Returns an empty string if no result is found.
    var rawOutput: String { resolver.rawOutput }

    /// Will return`true` if the `input` is equal to `.void`.
    var isVoidInput: Bool { input.isVoid }

    /// Will return`true` if the `typeAnnotation` is a closure and the input is a void block. i.e `() -> (Void)/() -> (())`.
    var isVoidOutput: Bool { output.isVoid }

    /// Will return`true` if the `output` is equal to `.void`.
    var isOptional: Bool { resolver.isOptional }

    /// Bool whether the closure has the `@escaping` attribute.
    /// **Note:** This separate from the `isAutoEscaping` proeprty as you may want to know whether something has the attribute or not.
    var isEscaping: Bool { resolver.isEscaping }

    /// Bool whether the closure is auto escaping.
    /// This would be `true` when the closure itself is optional as swift expects them to be auto-escaping.
    var isAutoEscaping: Bool { resolver.isOptional }

    /// The full declaration string.
    var declaration: String { description }

    // MARK: - Properties: Convenience

    var resolver: ClosureSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Closure`` instance from an `FunctionTypeSyntax` node.
    public init(node: FunctionTypeSyntax) {
        resolver = ClosureSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: Closure, rhs: Closure) -> Bool {
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
