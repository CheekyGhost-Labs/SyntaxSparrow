//
//  EntityType+Parsing.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension EntityType {

    var isVoid: Bool {
        switch self {
        case .void:
            return true
        default:
            return false
        }
    }

    static func parseType(_ typeSyntax: TypeSyntaxProtocol) -> EntityType {
        // Simple
        if let simpleType = typeSyntax.as(SimpleTypeIdentifierSyntax.self) {
            // Result
            if simpleType.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Result") {
                let result = Result(simpleType)
                return .result(result!)
            }
            let isOptional = simpleType.resolveIsOptional()
            // Void
            if
                simpleType.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("Void") ||
                simpleType.firstToken(viewMode: .fixedUp)?.tokenKind == .identifier("()")
            {
                return .void(isOptional)
            }

            // Standard
            return .simple(simpleType.description.trimmed, isOptional)
        }

        // Tuple
        if let tupleTypeSyntax = typeSyntax.as(TupleTypeSyntax.self) {
            if tupleTypeSyntax.elements.count == 1, let innerElement = tupleTypeSyntax.elements.first {
                return parseType(innerElement.type)
            } else if tupleTypeSyntax.elements.isEmpty {
                let isOptional = tupleTypeSyntax.resolveIsOptional()
                return .void(isOptional)
            }
            let tuple = Tuple(node: tupleTypeSyntax)
            return .tuple(tuple)
        }

        // Closure
        if let functionTypeSyntax = typeSyntax.as(FunctionTypeSyntax.self) {
            let closure = Closure(node: functionTypeSyntax)
            return .closure(closure)
        }

        if let optionalType = typeSyntax.as(OptionalTypeSyntax.self) {
            return parseType(optionalType.wrappedType)
        }

        if let attributedType = typeSyntax.as(AttributedTypeSyntax.self) {
            return parseType(attributedType.baseType)
        }

        // Result
        return .empty
    }

    static func parseElementList(_ syntax: TupleTypeElementListSyntax) -> EntityType {
        let tuple = Tuple(node: syntax)
        if getEmptyTuple(tuple) != nil {
            let isOptional = syntax.resolveIsOptional()
            return .void(isOptional)
        }
        // This is probably not needed?
        if let resolvedSingleElement = getSingleTupleElement(tuple) {
            return resolvedSingleElement
        }
        return .tuple(tuple)
    }

    static func getEmptyTuple(_ tuple: Tuple) -> Tuple? {
        // If the tuple is empty, return the tuple
        if tuple.elements.isEmpty {
            return tuple
        }
        // If the tuple has more than one element return nil
        if tuple.elements.count > 1 {
            return nil
        }

        // Check if the first (and only) element is a tuple
        if case let .tuple(nestedTuple) = tuple.elements.first?.type {
            // Recursively get the nested tuple
            return getEmptyTuple(nestedTuple)
        }

        // If the first (and only) element is not a tuple, return the tuple itself
        return tuple
    }

    // This is probably not needed
    static func getSingleTupleElement(_ tuple: Tuple) -> EntityType? {
        guard tuple.elements.count == 1 else { return nil }
        if let result = tuple.elements.first?.type {
            return result
        }
        return nil
    }
}
