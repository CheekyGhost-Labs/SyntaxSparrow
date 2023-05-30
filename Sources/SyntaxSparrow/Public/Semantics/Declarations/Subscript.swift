//
//  Subscript.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `Subscript` is a struct representing a Swift structure declaration. This struct is part of the SyntaxSparrow library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Subscript` corresponds to a `SubscriptDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties.
public struct Subscript: Declaration, SyntaxSourceLocationResolving {

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

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: SubscriptSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Subscript`` instance from an `SubscriptDeclSyntax` node.
    public init(node: SubscriptDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = SubscriptSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        // no-op
    }

    // MARK: - Equatable

    public static func == (lhs: Subscript, rhs: Subscript) -> Bool {
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
