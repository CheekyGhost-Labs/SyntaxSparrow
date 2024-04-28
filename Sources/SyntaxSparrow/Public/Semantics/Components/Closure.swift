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
public struct Closure: DeclarationComponent {
    // MARK: - Properties: DeclarationComponent

    public var node: FunctionTypeSyntax { resolver.node }

    // MARK: - Properties

    /// Will return the closure input element from the input `typeAnnotation` for the closure.
    /// **Note:** This will **always** resolve to ``EntityType/tuple`` with one or more parameters
    /// or ``EntityType/tuple`` if there are no inputs. i.e
    /// ```swift
    /// - ((name: inout String, age: Int) -> Void
    /// - (inout String, Int) -> Void
    /// - (String) -> Void
    /// - () -> Void
    /// ```
    /// will result in:
    /// - ``EntityType/tuple`` with a single tuple element. The single tuple element will have the `name: inout String` and `age: Int` elements
    /// - ``EntityType/tuple`` with two elements. The inout `String` and the `Int`
    /// - ``EntityType/tuple`` with a single element. The `String`
    /// - ``EntityType/void``.
    public var input: EntityType { resolver.resolveInput() }

    /// Will return the input string for the closure. Returns an empty string if no result is found.
    public var rawInput: String { resolver.resolveRawInput() }

    /// Will return the closure output elements from the input `typeAnnotation` for the closure.
    public var output: EntityType { resolver.resolveOutput() }

    /// Will return the return type string for the closure. Returns an empty string if no result is found.
    public var rawOutput: String { resolver.resolveRawOutput() }

    /// Will return`true` if the `input` is equal to `.void`.
    public var isVoidInput: Bool { input.isVoid }

    /// Will return`true` if the `typeAnnotation` is a closure and the input is a void block. i.e `() -> (Void)/() -> (())`.
    public var isVoidOutput: Bool { output.isVoid }

    /// Will return`true` if the `output` is equal to `.void`.
    public var isOptional: Bool { resolver.resolveIsOptional() }

    /// Bool whether the closure has the `@escaping` attribute.
    /// **Note:** This separate from the `isAutoEscaping` proeprty as you may want to know whether something has the attribute or not.
    public var isEscaping: Bool { resolver.resolveIsEscaping() || isAutoEscaping }

    /// Bool whether the closure is auto escaping.
    /// This would be `true` when the closure itself is optional as swift expects them to be auto-escaping.
    public var isAutoEscaping: Bool { resolver.resolveIsOptional() }

    /// The full declaration string.
    public var declaration: String { description }

    /// Struct representing the state of any effect specifiers on the initializer signature.
    ///
    /// For example, your accessor might support structured concurrency:
    /// ```swift
    /// var name: String {
    ///    func performAndWait<T>(_ block: () throws -> T) async rethrows -> T
    /// }
    /// ```
    /// in which case the `effectSpecifiers` property would be present and output:
    /// - `effectSpecifiers.throwsSpecifier` // `"throws"`
    /// - `effectSpecifiers.asyncAwaitKeyword` // `nil`
    ///
    /// **Note:** `effectSpecifiers` will be `nil` if no specifiers are found on the node.
    public var effectSpecifiers: EffectSpecifiers? { resolver.resolveEffectSpecifiers() }

    // MARK: - Properties: Convenience

    private(set) var resolver: ClosureSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Closure`` instance from an `FunctionTypeSyntax` node.
    public init(node: FunctionTypeSyntax) {
        resolver = ClosureSemanticsResolver(node: node)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        let base = node.description.trimmed
        return isOptional ? "(\(base))?" : base
    }
}
