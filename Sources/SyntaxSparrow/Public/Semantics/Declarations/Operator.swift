//
//  Operator.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift operator declaration.
///
/// In Swift, operators are special functions or methods that provide
/// compact, expressive syntax for complex operations.
/// Swift supports three kinds of operators: prefix, infix, and postfix.
///
/// For example, in the declaration `infix operator +: AdditionPrecedence`,
/// the operator `+` is declared as an infix operator in the precedence group `AdditionPrecedence`.
///
/// Each instance of ``SyntaxSparrow/Operator`` corresponds to an `OperatorDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration` and `SyntaxSourceLocationResolving`, which provides
/// access to the declaration attributes, modifiers, and source location information.
public struct Operator: Declaration, SyntaxSourceLocationResolving {
    /// Enumeration of possible operator kinds.
    public enum Kind: String, Hashable, Codable {
        /// A unary operator that comes before its operand.
        /// For example, in the expression `-x`, `-` is a prefix operator.
        case prefix
        /// A binary operator that comes between its operands.
        /// For example, in the expression `x + y`, `+` is an infix operator.
        case infix
        /// A unary operator that comes after its operand.
        /// Swift does not natively support postfix operators beyond the existing ones like `x!` or `x?`.
        case postfix

        /// Initializer that accepts a list of modifiers and returns the first valid operator kind found, if any.
        public init?(_ modifiers: [Modifier]) {
            guard let mapped = modifiers.compactMap({ Kind(rawValue: $0.name) }).first else {
                return nil
            }
            self = mapped
        }

        /// Initializer that accepts a fixety token and returns the first valid operator kind found, if any.
        public init?(_ token: TokenSyntax) {
            switch token.tokenKind {
            case .keyword(.prefix):
                self = .prefix
            case .keyword(.infix):
                self = .infix
            case .keyword(.postfix):
                self = .postfix
            default:
                return nil
            }
        }
    }

    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    @available(
        swift,
        deprecated: 5.9, obsoleted: 5.9,
        message: "Swift is dropping support for operator attributes in 5.9."
    )
    @available(
        *,
         deprecated,
         message: "SyntaxSparrow is removing support for operator attributes in version 2.0 to align with Swift 5.9 and latest SwiftSyntax."
    )
    public var attributes: [Attribute] { resolver.attributes }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    @available(
        swift,
        deprecated: 5.9, obsoleted: 5.9,
        message: "Swift is dropping support for operator modifiers in 5.9."
    )
    @available(
        *,
         deprecated,
         message: "SyntaxSparrow is removing support for operator modifiers in version 2.0 to align with Swift 5.9 and latest SwiftSyntax."
    )
    public var modifiers: [Modifier] { resolver.modifiers }

    /// The declaration keyword.
    ///
    /// i.e: `"operator"`
    public var keyword: String { resolver.keyword }

    /// The operator name.
    ///
    /// i.e: `prefix operator +++` would have a name of `"+++"`
    /// If the operator is unnamed, this will be an empty string.
    public var name: String { resolver.name }

    /// The kind of operator (prefix, infix, or postfix).
    public var kind: Kind { resolver.kind ?? .infix }

    // MARK: - Properties: SyntaxSourceLocationResolving

    /// The location of the operator declaration in the source code.
    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties

    /// An object that resolves semantic information about the operator.
    private(set) var resolver: OperatorSemanticsResolver

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Operator`` instance from an `OperatorDeclSyntax` node.
    public init(node: OperatorDeclSyntax, context: SyntaxExplorerContext) {
        resolver = OperatorSemanticsResolver(node: node, context: context)
    }

    // MARK: - Equatable

    public static func == (lhs: Operator, rhs: Operator) -> Bool {
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
