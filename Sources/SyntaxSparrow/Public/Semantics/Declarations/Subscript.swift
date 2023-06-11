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
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"func"`
    public var keyword: String { resolver.keyword }

    /// The subscript parameter indices
    public var indices: [Parameter] { resolver.indices }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// func performOperation<T: Equatable>(input: T) {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// func performOperation<T>(input: T) where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    /// The return type of the subscript.
    public var returnType: EntityType { resolver.returnType }

    /// The subscript getter and/or setter.
    public var accessors: [Accessor] { resolver.accessors }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: SubscriptSemanticsResolver

    // MARK: - Lifecycle

    public init(node: SubscriptDeclSyntax) {
        resolver = SubscriptSemanticsResolver(node: node)
    }

    // TODO: Enable child collection within get/set blocks (may need to expose the get/set blocks too)?
}
