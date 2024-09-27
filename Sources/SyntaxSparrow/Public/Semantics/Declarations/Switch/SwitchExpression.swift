//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public struct SwitchExpression: Declaration {

    // MARK: - Supplementary
    
    /// Enumeration of supported expression types.
    ///
    /// The expression refers to the type identifier following the `switch` prefix.
    /// For example,
    /// ```swift
    /// switch someType { ... }
    /// switch (lhs, rhs) { ... }
    /// switch (lhs as? Int, rhs as? Int) { ... }
    /// ```
    /// - The first expression is `.identifier("someType")`
    /// - The second expression is `.tuple("lhs", "rhs")`
    /// - The third expression is `.tuple("lhs as? Int", "rhs as? Int")`
    public enum ExpressionIdentifier: Equatable, Hashable, CustomStringConvertible {
        case identifier(identifier: String)
        case tuple(elements: [String])
        case unsupported(identifier: String)

        public var description: String {
            switch self {
            case .identifier(let identifier), .unsupported(let identifier):
                return identifier
            case .tuple(let elements):
                return "(\(elements.joined(separator: ", ")))"
            }
        }

        public init(_ node: ExprSyntax) {
            if let identifier = node.as(DeclReferenceExprSyntax.self) {
                self = .identifier(identifier: identifier.trimmedDescription)
            } else if let tuple = node.as(TupleExprSyntax.self) {
                let elements = tuple.elements.trimmedDescription.components(separatedBy: ",").map(\.trimmed)
                self = .tuple(elements: elements)
            } else {
                self = .unsupported(identifier: node.trimmedDescription)
            }
        }
    }

    /// Enumeration of supported switch case types
    @frozen // Monitor: Underlying swift token has frozen with a fixme
    public enum Case: Equatable, Hashable {
        case switchCase(SwitchExpression.SwitchCase)
        case ifConfig(ConditionalCompilationBlock)
    }

    // MARK: - Properties

    /// The identifier expression declared after the `switch` keyword.
    public var expression: ExpressionIdentifier { resolver.resolveExpression() }
    
    /// Array of ``SwitchExpression/CaseExpression`` items found in the declaration.
    ///
    /// **Note:** This approach was taken as the `SwiftSyntax` library is currently processing this with an `@frozen` attribute
    /// noting it is a compiler work-around. The enumeration will contain the case declaration itself, which has labels, keywords, code statements etc
    /// - See: ``SwitchExpression/CaseExpression``
    public var cases: [Case] { resolver.resolveCases() }

    /// Textual representation of the expression.
    /// - See: ``SwitchExpression/Expression``
    public var identifier: String { expression.description }

    /// The switch expression keyword. i.e `"switch"`
    public var keyword: String { resolver.resolveKeyword() }

    // MARK: - Properties: Declaration

    public var node: SwitchExprSyntax { resolver.node }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: SwitchExpressionSemanticsResolver

    // MARK: - Lifecycle

    public init(node: SwitchExprSyntax) {
        resolver = SwitchExpressionSemanticsResolver(node: node)
    }
}
