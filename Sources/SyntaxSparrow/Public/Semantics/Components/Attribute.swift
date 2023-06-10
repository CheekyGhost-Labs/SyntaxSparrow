//
//  Attribute.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax

/// Represents a Swift attribute declaration. An attribute provides metadata about a declaration or type. In Swift, they appear before a declaration,
/// preceded by the @ symbol.
///
/// For example: `@available(*, unavailable, message: "this is not available")`, `@discardableResult` etc
///
/// An instance of the `Attribute` struct provides access to:
/// - The name of the attribute, which is the identifier that follows the @ symbol.
/// - Any arguments that the attribute takes. Some attributes can take one or more arguments with a value and optional name.Arguments are represented
/// by the nested `Argument` struct.
///
/// The `Attribute` struct also includes functionality to create an attribute instance from an `AttributeSyntax` node and
/// create an array of attribute instances from an `AttributeListSyntax` node.
public struct Attribute: DeclarationComponent {
    // MARK: - Supplementary

    /// Struct representing an attribute declaration argument.
    /// Some attributes take one or more arguments, each having a value and optional name.
    /// For example, the following attribute has three arguments:
    /// ```swift
    /// @available(*, unavailable, message: "my message")
    /// ```
    /// - The first argument has no `name` and the `value` `"*"`
    /// - The second argument has no `name` and the `value` `"unavailable"`
    /// - The third argument has the `name` `"message"` and the `value` `"my message"`
    public struct Argument: Hashable, Equatable {
        // MARK: - Properties

        /// The argument name, if any.
        public let name: String?

        /// The argument value.
        public let value: String

        public var description: String {
            let components: [String] = [name, value].compactMap { $0 }
            return components.joined(separator: ":")
        }

        public init(name: String?, value: String) {
            self.name = name?.trimmed
            self.value = value.trimmed
        }
    }

    // MARK: - Properties: DeclarationComponent

    public var node: AttributeSyntax { resolver.node }

    // MARK: - Properties

    /// The attribute name.
    /// An attribute name is everything after the `@` symbol, but before the argument clause.
    /// For example, in the following attribute the name would be `available`
    /// ```swift
    /// @available(macOS 10.15, iOS 13, *)
    /// ```
    public var name: String { resolver.name }

    /// Array of attribute ``Attribute/Argument`` instances (if any).
    public var arguments: [Argument] { resolver.arguments }

    // MARK: - Properties: SyntaxChildCollecting

    private(set) var resolver: AttributeSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Attribute`` instance from an `AttributeSyntax` node.
    public init(node: AttributeSyntax) {
        resolver = AttributeSemanticsResolver(node: node)
    }

    public static func fromAttributeList(_ node: AttributeListSyntax?) -> [Attribute] {
        guard let listNode = node else { return [] }
        let results = listNode.compactMap {
            if let node = $0.as(AttributeSyntax.self) {
                return Attribute(node: node)
            }
            return nil
        }
        return results
    }
}
