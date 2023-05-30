//
//  Function.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a Swift function declaration.
///
/// Functions are self-contained chunks of code that perform a specific task. In Swift,
/// functions are declared with the `func` keyword.
///
/// Each instance of ``SyntaxSparrow/Function`` corresponds to an `FunctionDeclSyntax` node in the Swift syntax tree.
///
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, and `SyntaxSourceLocationResolving`,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Function: Declaration, SyntaxChildCollecting, SyntaxSourceLocationResolving {

    // MARK: - Supplementary

    /// Struct representing a function signature.
    ///
    /// The signature describes the function's parameter types and return type.
    /// This information is parsed from an underlying `FunctionSignatureSyntax` token.
    public struct Signature: Hashable {

        // MARK: - Properties

        /// Array of input parameters for the function.
        /// Each parameter is represented by a `Parameter` struct.
        public let input: [Parameter]

        /// The function output type, if any.
        /// This is the return type of the function.
        public let output: EntityType?

        /// The `throws` or `rethrows` keyword, if any.
        /// Indicates whether the function can throw an error.
        public let throwsOrRethrowsKeyword: String?
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
    /// i.e: `"func"` for function declarations.
    public var keyword: String { resolver.keyword }


    /// The function identifier (similar to name).
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func performOperation(withName name: String) -> String
    /// ```
    /// - The `identifier` is equal to `performOperation`
    public var identifier: String { resolver.identifier }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// func performOperation<T: Equatable>(input: T) {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.genericParameters }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// func performOperation<T>(input: T) where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.genericRequirements }

    /// Struct representing the function signature.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func performOperation(withName name: String) throws -> String
    /// ```
    /// The signature will have:
    /// - An `input` equal to an array with a single `Parameter` item.
    /// - An `output` equal to `EntityType.simple("String")`
    /// - A `throwsOrRethrowsKeyword` equal to `"throws"`
    public var signature: Function.Signature { resolver.signature }

    /// `Bool` whether the subscript is a valid operator type.
    public var isOperator: Bool { resolver.isOperator }

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: FunctionSemanticsResolver

    var declarationCollection: DeclarationCollection { resolver.declarationCollection }

    // MARK: - Lifecycle

    public init(node: FunctionDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = FunctionSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        resolver.collectChildren()
    }

    // MARK: - Equatable

    public static func == (lhs: Function, rhs: Function) -> Bool {
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

extension Function: DeclarationCollecting {}
