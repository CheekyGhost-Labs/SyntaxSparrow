//
//  File.swift
//  
//
//  Created by Michael O'Brien on 25/6/2023.
//

import Foundation
import SwiftSyntax

public extension SwitchExpression.SwitchCase {

    /// Enumeration representing supported switch case item types.
    enum Item: Equatable, Hashable, CustomStringConvertible {
        // MemberAccessor
            // .member
        case member(name: String)
        // ValueBindingPattern>MemberAccessor>
            // let/var .member(accessors)
        case valueBindingMember(keyWord: String, name: String, elements: [String])
        // FunctionCall>(MemberAccessor+TupleExpr)
            // .member(let accessor):
        case innerValueBindingMember(name: String, elements: [String: String])
        // ValueBinding>ExpressionPattern>SequenceExpression>ExprList
          // let item as thing
        case valueBinding(keyWord: String, elements: [String])
        // General fallback to capture the node
        case unsupported(syntax: CaseItemSyntax)

        public var description: String {
            switch self {
            case .member(let name):
                return ".\(name)"
            case .valueBindingMember(let keyword, let name, let elements):
                let elementsList = elements.joined(separator: ", ")
                return "\(keyword) .\(name)(\(elementsList))"
            case .innerValueBindingMember(let name, let elements):
                let elementsMap = elements.map { "\($0.key) \($0.value)" }
                let elementsList = elementsMap.joined(separator: ", ")
                return ".\(name)(\(elementsList))"
            case .valueBinding(let keyWord, let elements):
                return "\(keyWord) \(elements.joined(separator: " "))"
            case .unsupported(let syntax):
                return syntax.description.trimmed
            }
        }

        // MARK: - Lifecycle

        public init(_ node: CaseItemSyntax) {
            if let memberItem = SwitchExpressionMemberCollector(viewMode: .fixedUp).collect(node) {
                self = memberItem
            } else if let internalBindingMember = SwitchExpressionInnerBindingMemberCollector(viewMode: .fixedUp).collect(node) {
                self = internalBindingMember
            } else if let valueBindingMember = SwitchExpressionValueBindingMemberCollector(viewMode: .fixedUp).collect(node) {
                self = valueBindingMember
            } else if let valueBinding = SwitchExpressionValueBindingCollector(viewMode: .fixedUp).collect(node) {
                self = valueBinding
            } else {
                self = .unsupported(syntax: node)
            }
        }
    }
}
