//
//  Attribute.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax

/// A declaration attribute.
/// Attributes provide additional information about a declaration, such as availability.
/// For example: `@available(*, unavailable, message: "this is not available")`, `@discardableResult` etc
public class Attribute: Equatable, Hashable, CustomStringConvertible {

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

    public init(node: AttributeSyntax) {
        self.resolver = AttributeSemanticsResolver(node: node)
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

    // MARK: - Equatable

    public static func == (lhs: Attribute, rhs: Attribute) -> Bool {
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
