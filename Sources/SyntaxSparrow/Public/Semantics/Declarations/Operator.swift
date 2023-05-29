//
//  Operator.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public struct Operator {

    /// Enumeration of possible operator kinds.
    public enum Kind: String, Hashable, Codable {
        /// A unary operator that comes before its operand.
        case prefix
        /// An binary operator that comes between its operands.
        case infix
        /// A unary operator that comes after its operand.
        case postfix

        public init?(_ modifiers: [Modifier]) {
            guard let mapped = modifiers.compactMap({ Kind(rawValue: $0.name) }).first else {
                return nil
            }
            self = mapped
        }
    }

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

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties

    private(set) var resolver: OperatorSemanticsResolver

    // MARK: - Lifecycle

    public init(_ node: OperatorDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = OperatorSemanticsResolver(node: node, context: context)
    }
}
