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

    public enum Expression: Equatable, Hashable, CustomStringConvertible {
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
    }

    /// Enumeration of supported switch case types
    @frozen // Monitor: Underlying swift token has frozen with a fixme
    public enum Case: Equatable, Hashable {
        case switchCase(SwitchExpression.SwitchCase)
        case ifConfig(ConditionalCompilationBlock)
    }

    // MARK: - Properties

    public var expression: Expression = .unsupported(identifier: "")

    public var cases: [Case] { resolver.resolveCases() }

    public var identifier: String { expression.description }

    // MARK: - Properties: Declaration

    public var node: SwitchExprSyntax { resolver.node }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: SwitchExpressionSemanticsResolver

    // MARK: - Lifecycle

    public init(node: SwitchExprSyntax) {
        resolver = SwitchExpressionSemanticsResolver(node: node)
    }
}
