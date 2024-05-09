//
//  Accessor.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift accessor declaration.
///
/// An accessor is a special kind of method that gets, sets, or computes the value of a variable. In Swift, they are typically found within property
/// and subscript declarations.
///
/// An instance of the `Accessor` struct provides access to:
/// - The kind of accessor, which can be `get` or `set`.
/// - Attributes associated with the accessor declaration, e.g., `@available`.
/// - Modifier applied to the accessor, e.g., `private`.
///
/// The `Accessor` struct also includes functionality to create an accessor instance from an `AccessorDeclSyntax` node.
public struct Accessor: DeclarationComponent, SyntaxChildCollecting {
    // MARK: - Supplementary

    /// The kind of accessor (`get` or `set`).
    public enum Kind: String, Hashable, Codable {
        /// A getter that returns a value.
        case get

        /// A setter that sets a value.
        case set

        /// Accessor invoked when something has been set.
        case didSet

        /// Accessor invoked when something is about to be set.
        case willSet
    }

    // MARK: - Properties: DeclarationComponent

    public let node: AccessorDeclSyntax

    // MARK: - Properties

    /// The accessor attributes.
    public let attributes: [Attribute]

    /// The accessor modifiers.
    public let modifier: Modifier?

    /// The kind of accessor.
    public let kind: Kind?

    /// Struct representing the state of any effect specifiers on the accessor.
    ///
    /// For example, your accessor might support structured concurrency:
    /// ```swift
    /// var name: String {
    ///    async get { "..." }
    /// }
    /// ```
    /// in which case the `effectSpecifiers` property would be present and output:
    /// - `effectSpecifiers.throwsSpecifier` // `nil`
    /// - `effectSpecifiers.asyncAwaitKeyword` // `"async"`
    ///
    /// **Note:** `effectSpecifiers` will be `nil` if no specifiers are found on the node.
    public let effectSpecifiers: EffectSpecifiers?

    /// The accessor code body (when present).
    /// An example when this would be `nil` would be within a protocol var declaration. For example:
    /// ```swift
    /// protocol MyProtocol {
    ///     var name: String { get set }
    /// }
    /// ```
    /// where as within a variable with a get/set, it would be present
    /// ```swift
    ///     var name: String {
    ///         get {
    ///             "name"
    ///         }
    ///         set {
    ///             self.name = newValue
    ///         }
    ///     }
    /// ```
    public let body: CodeBlock?

    /// Returns `true` when the ``Accessor/effectSpecifiers`` has the `throw` keyword.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// func example() throws
    /// ```
    public var isThrowing: Bool {
        return effectSpecifiers?.throwsSpecifier != nil
    }

    /// Returns `true` when the ``Accessor/effectSpecifiers`` has the `throw` keyword.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// func example() async
    /// ```
    public var isAsync: Bool {
        return effectSpecifiers?.asyncSpecifier != nil
    }

    // MARK: - Properties: SyntaxChildCollecting

    public var childCollection: DeclarationCollection {
        body?.childCollection ?? DeclarationCollection()
    }

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Accessor`` instance from an `AccessorDeclSyntax` node.
    public init(node: AccessorDeclSyntax) {
        self.node = node
        // Attributes
        attributes = Attribute.fromAttributeList(node.attributes)
        // Modifier
        if let modifierNode = node.modifier {
            modifier = Modifier(node: modifierNode)
        } else {
            modifier = nil
        }
        // Kind
        let rawKind = node.accessorSpecifier.text.trimmed
        kind = Kind(rawValue: rawKind)
        // Body
        if let body = node.body {
            self.body = CodeBlock(node: body)
        } else {
            body = nil
        }
        // effectSpecifier
        if let effectSpecifiers = node.effectSpecifiers {
            self.effectSpecifiers = EffectSpecifiers(node: effectSpecifiers)
        } else {
            effectSpecifiers = nil
        }
        collectChildren(viewMode: .fixedUp)
    }

    // MARK: - Conformance: SyntaxChildCollecting

    public func collectChildren(viewMode: SyntaxTreeViewMode) {
        body?.collectChildren(viewMode: viewMode)
    }
}
