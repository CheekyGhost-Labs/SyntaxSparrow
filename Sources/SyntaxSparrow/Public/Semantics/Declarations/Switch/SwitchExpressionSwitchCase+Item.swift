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
        /// Represents a literal accessor
        /// i.e `case "test"`, `case 123` etc
        case literal(value: String)
        /// Represents a basic member accessor.
        /// i.e `case .example`
        case member(name: String)
        /// Represents a member with an `IsTypePatternSyntax`
        /// i.e `case is SomeType`
        case isTypePattern(type: String)
        /// Represents a member accessor with a value binding prefix.
        /// i.e `case let .example(name, age)`
        case valueBindingMember(keyWord: String, name: String, elements: [String]) // should put optional assessment here
        /// Represents a member accessor with an internal value binding.
        /// i.e `case .example(let name, let age)`
        case innerValueBindingMember(name: String, elements: [String: String])
        /// Represents a value binding case assessor.
        /// i.e `case let item as SomeThing`
        case valueBinding(keyWord: String, elements: [String])
        /// Represents a tuple binding case assessor. // THIS COULD HAVE ANY OF THE ABOVE
        /// i.e `case (true, false)`
        case tuple(elements: [String])
        /// Represents a case that was not able to be resolved to one of the supported enumerations.
        /// Contains the case item syntax as an associated value.
        case unsupported(syntax: SwitchCaseItemSyntax)

        public var description: String {
            switch self {
            case .literal(let value):
                return ".\(value)"
            case .isTypePattern(let type):
                return "is \(type)"
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
            case .tuple(let elements):
                return "(\(elements.joined(separator: ", ")))"
            case .unsupported(let syntax):
                return syntax.trimmedDescription
            }
        }

        // MARK: - Lifecycle

        public init(_ node: SwitchCaseItemSyntax) {
            if let tupleItem = SwitchExpressionTupleCollector(viewMode: .fixedUp).collect(node) {
                self = tupleItem
            } else if let memberItem = SwitchExpressionMemberCollector(viewMode: .fixedUp).collect(node) {
                self = memberItem
            } else  if let isTypeBindingMember = SwitchExpressionIsTypeCollector(viewMode: .fixedUp).collect(node) {
                self = isTypeBindingMember
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
