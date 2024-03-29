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
/// This structure conforms to `Declaration` , which provides
/// access to the declaration attributes, modifiers, and source location information.
public struct Operator: Declaration {
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

    // MARK: - Properties: Declaration

    public var node: OperatorDeclSyntax { resolver.node }

    // MARK: - Properties

    /// The declaration keyword.
    ///
    /// i.e: `"operator"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The operator name.
    ///
    /// i.e: `prefix operator +++` would have a name of `"+++"`
    /// If the operator is unnamed, this will be an empty string.
    public var name: String { resolver.resolveName() }

    /// The kind of operator (prefix, infix, or postfix).
    public var kind: Kind { resolver.resolveKind() ?? .infix }

    // MARK: - Properties

    /// An object that resolves semantic information about the operator.
    private(set) var resolver: OperatorSemanticsResolver

    // MARK: - Lifecycle

    public init(node: OperatorDeclSyntax) {
        resolver = OperatorSemanticsResolver(node: node)
    }
}
