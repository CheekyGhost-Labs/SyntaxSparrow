//
//  EntityType+Parsing.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension EntityType {

    var isClosure: Bool {
        switch self {
        case .closure:
            return true
        default:
            return false
        }
    }

    var isTuple: Bool {
        switch self {
        case .closure:
            return true
        default:
            return false
        }
    }

    var isVoid: Bool {
        switch self {
        case .void:
            return true
        default:
            return false
        }
    }

    static func parseType(_ typeSyntax: TypeSyntaxProtocol, forceTuple: Bool = false) -> EntityType {
        // Simple
        if let simpleType = typeSyntax.as(IdentifierTypeSyntax.self) {
            // Result
            if let resultType = Result(simpleType) {
                return .result(resultType)
            }
            // Array
            if let arrayType = ArrayDecl(simpleType) {
                return .array(arrayType)
            }
            // Set
            if let setType = SetDecl(simpleType) {
                return .set(setType)
            }
            // Dictionary
            if let dictType = DictionaryDecl(simpleType) {
                return .dictionary(dictType)
            }
            let isOptional = simpleType.resolveIsTypeOptional()
            // Void check
            if
                let firstKind = simpleType.firstToken(viewMode: .fixedUp)?.tokenKind,
                let resolved = resolveVoidType(from: firstKind, isOptional: isOptional)
            {
                return resolved
            }

            let typeString = resolveSimpleTypeString(from: simpleType)
            return .simple(typeString)
        }

        // Array
        if let arrayTypeSyntax = typeSyntax.as(ArrayTypeSyntax.self) {
            let array = ArrayDecl(arrayTypeSyntax)
            return .array(array)
        }

        // Dictionary
        if let dictTypeSyntax = typeSyntax.as(DictionaryTypeSyntax.self) {
            let dict = DictionaryDecl(dictTypeSyntax)
            return .dictionary(dict)
        }

        // Tuple
        if let tupleTypeSyntax = typeSyntax.as(TupleTypeSyntax.self) {
            if tupleTypeSyntax.elements.count == 1, let innerElement = tupleTypeSyntax.elements.first, !forceTuple {
                return parseType(innerElement.type)
            } else if tupleTypeSyntax.elements.isEmpty {
                let isOptional = tupleTypeSyntax.resolveIsTypeOptional()
                return voidType(withRawValue: "()", isOptional: isOptional)
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

        // Fallback
        if !typeSyntax.description.trimmed.isEmpty {
            let typeString = resolveSimpleTypeString(from: typeSyntax)
            return .simple(typeString)
        }

        // Result
        return .empty
    }

    static func parseElementList(_ syntax: TupleTypeElementListSyntax, forceTuple: Bool = false) -> EntityType {
        let tuple = Tuple(node: syntax)
        if getEmptyTuple(tuple) != nil {
            let isOptional = syntax.resolveIsSyntaxOptional()
            return voidType(withRawValue: "()", isOptional: isOptional)
        }
        // This is probably not needed?
        if let resolvedSingleElement = getSingleTupleElement(tuple), !forceTuple {
            return resolvedSingleElement
        }
        return .tuple(tuple)
    }

    // MARK: - Helpers: Private

    private static func getEmptyTuple(_ tuple: Tuple) -> Tuple? {
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

        // If the first (and only) element is not a tuple, return nil
        return nil
    }

    // This is probably not needed
    private static func getSingleTupleElement(_ tuple: Tuple) -> EntityType? {
        guard tuple.elements.count == 1 else { return nil }
        if let result = tuple.elements.first?.type {
            return result
        }
        return nil
    }

    private static func resolveSimpleTypeString(from typeSyntax: TypeSyntaxProtocol) -> String {
        // Standard
        let isOptional = typeSyntax.resolveIsTypeOptional()
        var simpleType = typeSyntax.description.trimmed
        // Need to check if parent parameter context (if any) is an optional. This has no parent parameter context so the type atm
        // has no context. i.e if we had `"String?..." as the parameter type, the `simpleType` at the moment is "String".
        // This developers looking at an `EntityType` outside of a parameter or variable context obtain the optional state both from the
        // enum case, and receive an accurate text description.
        if isOptional {
            simpleType += "?"
        }
        if let ellipsis = resolveEllipsisToken(from: typeSyntax) {
            simpleType += ellipsis.text.trimmed
        }
        return simpleType.trimmed
    }

    private static func resolveEllipsisToken(from typeSyntax: TypeSyntaxProtocol) -> TokenSyntax? {
        let enumParentType = EnumCaseParameterClauseSyntax.self
        if let enumParent = typeSyntax.firstParent(returning: { $0.as(enumParentType) })?.as(enumParentType) {
            guard
                let unexpectedToken = enumParent.unexpectedBetweenParametersAndRightParen,
                let tokenChild = unexpectedToken.children(viewMode: .fixedUp).first?.as(TokenSyntax.self),
                tokenChild.tokenKind == .postfixOperator("...")
            else {
                return nil
            }
            return tokenChild
        }
        // Need to check if ellipsis is present after type to declare variadic. This has no parent parameter context so the type atm
        // has no context. i.e if we had `"String?..." as the parameter type, the `simpleType` at the moment is "String?"
        // This developers looking at an `EntityType` outside of a parameter or variable context obtain the accurate variadic type in
        // the text description
        var ellipsisToken: TokenSyntax?
        var nextToken = typeSyntax.nextToken(viewMode: .fixedUp)
        while nextToken != nil {
            if let candidate = nextToken, candidate.tokenKind == .ellipsis, candidate.context?.id == typeSyntax.context?.id {
                ellipsisToken = candidate
                break
            }
            nextToken = nextToken?.nextToken(viewMode: .fixedUp)
        }
        return ellipsisToken
    }

    private static func resolveVoidType(from tokenKind: TokenKind, isOptional: Bool) -> EntityType? {
        switch tokenKind {
        case .identifier("Void"):
            return voidType(withRawValue: "Void", isOptional: isOptional)
        case .identifier("()"):
            return voidType(withRawValue: "()", isOptional: isOptional)
        default:
            return nil
        }
    }

    private static func voidType(withRawValue value: String, isOptional: Bool) -> EntityType {
        var rawType: String = value
        if isOptional {
            rawType += "?"
        }
        return .void(rawType, isOptional)
    }
}
