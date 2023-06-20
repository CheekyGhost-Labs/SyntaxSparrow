//
//  Initializer.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift initializer declaration.
///
/// Initializers are special methods that provide new instances of a particular type.
/// In its simplest form, an initializer is like an instance method with no parameters,
/// written using the `init` keyword.
///
/// For example, in the declaration `init()` or `init?()`, an initializer is declared for a type.
/// The `init?()` denotes an optional initializer that can return `nil`.
///
/// Each instance of ``SyntaxSparrow/Initializer`` corresponds to an `InitializerDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Initializer: Declaration, SyntaxChildCollecting {
    // MARK: - Properties: Declaration

    public var node: InitializerDeclSyntax { resolver.node }

    // MARK: - Properties

    /// Flag indicating whether the initializer is optional (can return `nil`).
    ///
    /// If `true`, the initializer is declared with a `?` (e.g., `init?()`), which means it can return `nil`.
    /// If `false`, the initializer is a regular initializer (e.g., `init()`).
    public var isOptional: Bool { resolver.resolveIsOptional() }

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"init"` for initializers
    public var keyword: String { resolver.resolveKeyword() }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// init<T: Equatable>(input: T) {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// init<T>(input: T) where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    /// Array of input parameters for the initializer.
    public var parameters: [Parameter] { resolver.resolveParameters() }

    /// The `throws` or `rethrows` keyword, if any.
    @available(
        *,
        deprecated,
        message: "`throwsOrRethrowsKeyword` will be deprecated in 2.0 - Please use `effectSpecifiers.throwsSpecifier` instead"
    )
    public var throwsOrRethrowsKeyword: String? { effectSpecifiers?.throwsSpecifier }

    /// Struct representing the state of any effect specifiers on the initializer signature.
    ///
    /// For example, your accessor might support structured concurrency:
    /// ```swift
    /// var name: String {
    ///    init() async throws { ... }
    /// }
    /// ```
    /// in which case the `effectSpecifiers` property would be present and output:
    /// - `effectSpecifiers.throwsSpecifier` // `"throws"`
    /// - `effectSpecifiers.asyncAwaitKeyword` // `"async"`
    ///
    /// **Note:** `effectSpecifiers` will be `nil` if no specifiers are found on the node.
    public var effectSpecifiers: EffectSpecifiers? { resolver.resolveEffectSpecifiers() }

    // MARK: - Properties: Resolving

    private(set) var resolver: InitializerSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection = .init()

    // MARK: - Lifecycle

    public init(node: InitializerDeclSyntax) {
        resolver = InitializerSemanticsResolver(node: node)
    }
}
