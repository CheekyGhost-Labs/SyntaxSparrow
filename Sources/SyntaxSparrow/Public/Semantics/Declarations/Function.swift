//
//  File.swift
//  
//
//  Created by Michael O'Brien on 22/5/2023.
//

import Foundation
import SwiftSyntax

/// `Function` is a struct representing a Swift structure declaration. This class is part of the SyntaxSparrow library, which provides an interface for
/// traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Function` corresponds to a `FunctionDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties.
public struct Function: Declaration, SyntaxSourceLocationResolving {

    // MARK: - Supplementary

    /// Struct representing a function signature.
    ///
    /// A signature is parsed from an underlying `FunctionSignatureSyntax` token. This struct
    /// is used to more accurately represent the `FunctionDeclSyntax` structure.
    public struct Signature: Hashable {

        // MARK: - Properties

        /// Array of input parameters for the function
        public let input: [Parameter]

        /// The function output type (if any)
        public let output: EntityType?

        /// The `throws` or `rethrows` keyword, if any.
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
    /// i.e: `"func"`
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

    // TODO: add isOperator once Operator support added

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: FunctionSemanticsResolver

    // MARK: - Lifecycle

    public init(node: FunctionDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = FunctionSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        // no-op
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
