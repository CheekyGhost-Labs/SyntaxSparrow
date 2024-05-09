//
//  Subscript.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift subscript declaration.
///
/// An instance of the `Subscript` struct provides access to various components of the subscript declaration it represents, including:
/// - Attributes: Any attributes associated with the declaration, e.g., `@available`.
/// - Modifiers: Modifiers applied to the subscript, e.g., `public`.
/// - Keyword: The keyword used for the declaration, i.e., "subscript".
/// - Indices: The parameters used as indices in the subscript.
/// - GenericParameters: Any generic parameters used in the subscript definition, along with their constraints.
/// - GenericRequirements: Information about any generic requirements applied to the subscript.
/// - ReturnType: The return type of the subscript.
/// - Accessors: The subscript's getter and/or setter.
///
/// Each instance of ``SyntaxSparrow/Structure`` corresponds to a `StructDeclSyntax` node in the Swift syntax tree.
///
/// The `Subscript` struct also conforms to `SyntaxSourceLocationResolving`, allowing you to determine where in the source file the subscript
/// declaration is located.
public struct Subscript: Declaration {
    // MARK: - Properties: Declaration

    public var node: SubscriptDeclSyntax { resolver.node }

    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"subscript"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The subscript parameter indices
    public var indices: [Parameter] { resolver.resolveIndices() }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// func performOperation<T: Equatable>(input: T) {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// func performOperation<T>(input: T) where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

    /// The return type of the subscript.
    public var returnType: EntityType { resolver.resolveReturnType() }

    /// Bool indicating whether the resolved `returnType` property is optional.
    ///
    /// For example:
    /// ```swift
    /// subscript(key: Int) -> String?
    /// subscript(key: Int) -> String
    /// ```
    /// - The first subscript `returnType` is `.simple("String?")` and `returnTypeIsOptional` is `true`
    /// - The first subscript `returnType` is `.simple("String")` and `returnTypeIsOptional` is `false`
    public var returnTypeIsOptional: Bool { resolver.resolveReturnTypeIsOptional() }

    /// The subscript getter and/or setter.
    public var accessors: [Accessor] { resolver.resolveAccessors() }

    /// Will return `true` when the `.set` accessor kind is present
    public var hasSetter: Bool { resolver.resolveHasSetter() }

    /// Returns `true` when there is a getter accessor that has the `throw` keyword.
    ///
    /// **Note:** Assesses the ``Accessor/effectSpecifiers`` property of the getter accessor  within the``Subscript/accessors`` array.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// subscript(index: Int) -> Int {
    ///     get throws { 0 }
    /// }
    /// ```
    public var isThrowing: Bool {
        return accessors.contains(where: { $0.kind == .get && $0.effectSpecifiers?.throwsSpecifier != nil })
    }

    /// Returns `true` when there is a getter accessor that has the `async` keyword.
    ///
    /// **Note:** Assesses the ``Accessor/effectSpecifiers`` property of the getter accessor within the``Subscript/accessors`` array.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// subscript(index: Int) -> Int {
    ///     get async { 0 }
    /// }
    /// ```
    public var isAsync: Bool {
        return accessors.contains(where: { $0.kind == .get && $0.effectSpecifiers?.asyncSpecifier != nil })
    }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: SubscriptSemanticsResolver

    // MARK: - Lifecycle

    public init(node: SubscriptDeclSyntax) {
        resolver = SubscriptSemanticsResolver(node: node)
    }

    // TODO: Enable child collection within get/set blocks (may need to expose the get/set blocks too)?
}
