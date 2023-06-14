//
//  PrecedenceGroup.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `PrecedenceGroup` represents the metadata of an operator's precedence group.
///
/// In Swift, operators belong to a certain precedence group. This precedence group determines how an operator interacts with
/// other operators and how expressions involving this operator are evaluated.
///
/// Precedence groups have several properties that affect this interaction, including the group's associativity, assignment and the relation to other
/// groups.
///
/// A precedence group is defined using the `precedencegroup` keyword followed by the group's name and body. The body contains the group's properties.
///
/// ```swift
/// precedencegroup MultiplicationPrecedence {
///     higherThan: AdditionPrecedence
///     associativity: left
///     assignment: false
/// }
/// ```
///
/// Here, the precedence group `MultiplicationPrecedence` has a higher precedence than `AdditionPrecedence`, a left associativity, and the
/// operators in this group are not assignment operators.
///
/// A `PrecedenceGroup` instance provides access to these properties as well as source code location and any attached attributes or modifiers.
///
/// Each instance of ``SyntaxSparrow/PrecedenceGroup`` corresponds to an `PrecedenceGroupDeclSyntax` node in the Swift syntax tree.
///
/// This type conforms to the `Declaration` protocol, `SyntaxSourceLocationResolving` protocol, `Equatable`, `Hashable`, and
/// `CustomStringConvertible`.
public struct PrecedenceGroup: Declaration {
    // MARK: - Supplementary

    /// Enumeration of associativity types for an operator.
    ///
    /// This determines how operators of the same precedence are grouped in the absence of parentheses.
    ///
    /// For example, in the following expression:
    /// ```swift
    /// a ~ b ~ c
    /// ```
    /// - If the `~` is the `.left` associative then the expression is interpreted as `(a ~ b) ~ c`
    /// - If the `~` is the `.right` associative then the expression is interpreted as `a ~ (b ~ c)`
    ///
    /// For example, the Swift subtraction operator: `-` is a `.left` associative, which means that:
    /// ```swift
    /// 5 - 7 - 2
    /// ```
    /// evaluates to:
    /// ```swift
    /// -4 // (5 - 7) - 2
    /// ```
    /// rather than:
    /// ```swift
    /// `0` // 5 - (7 - 2)
    /// ```
    public enum Associativity: String, Equatable, Hashable {
        case left
        case right
    }

    /// The relation of operators to operators in other precedence groups.
    ///
    /// This determines the order in which operators of different precedence groups are evaluated in the absence of parentheses.
    ///
    /// For example,
    /// ```swift
    /// a ⧓ b ⧗ c
    /// ```
    /// - If the `⧓` operator has the `.higherThan` relation than the expression is interpreted as `(a ⧓ b) ⧓ c`
    /// - If the `⧓` operator has the `.lowerThan` relation than the expression is interpreted as `a ⧓ (b ⧓ c)`
    ///
    /// For example,
    /// Swift mathematical operators have the same inherent precedence as their corresponding arethmetic operations. This means that:
    /// ```swift
    /// 1 + 2 * 3
    /// ```
    /// evaluates to:
    /// ```swift
    /// 7 // 1 + (2 * 3)
    /// ```
    /// rather than:
    /// ```swift
    /// 9 // (1 + 2) * 3
    /// ```
    public enum Relation: Equatable, Hashable {
        /// The precedence group has a **higher** precedence than the associated group names.
        case higherThan([String])
        /// The precedence group has a **lower** precedence than the associated group names.
        case lowerThan([String])
    }

    // MARK: - Properties: Declaration

    public var node: PrecedenceGroupDeclSyntax { resolver.node }

    // MARK: - Properties

    /// The declaration keyword.
    ///
    /// i.e: `"precedencegroup"`
    public var keyword: String { resolver.resolveKeyword() }

    /// The precedence group name.
    public var name: String { resolver.resolveName() }

    /// `Bool` whether the operators in the precedence group are folded into optional chains.
    ///
    /// For example, if `assignment` is `true`, the expression `entry?.count += 1` has the effect of `entry?(.count += 1)`
    /// otherwise the same expression would be interpreted as `(entry?.count) += 1` which would fail to type-check.
    public var assignment: Bool? { resolver.resolveAssignment() }

    /// The associativity of operators in the precedence group.
    /// - See: ``SyntaxSparrow/PrecedenceGroup/Associativity-swift.enum``
    public var associativity: Associativity? { resolver.resolveAssociativity() }

    /// The relation of operators to operators in other precedence groups.
    /// - See: ``SyntaxSparrow/PrecedenceGroup/Associativity-swift.enum``
    public var relations: [Relation] { resolver.resolveRelations() }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: PrecedenceGroupSemanticsResolver

    // MARK: - Lifecycle

    public init(node: PrecedenceGroupDeclSyntax) {
        resolver = PrecedenceGroupSemanticsResolver(node: node)
    }
}
