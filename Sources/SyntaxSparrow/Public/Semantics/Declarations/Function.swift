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
/// This structure conforms to `Declaration`, `SyntaxChildCollecting`, ,
/// which provide access to the declaration attributes, modifiers, child nodes, and source location information.
public struct Function: Declaration, SyntaxChildCollecting {
    // MARK: - Supplementary

    /// Struct representing a function signature.
    ///
    /// The signature describes the function's parameter types and return type.
    /// This information is parsed from an underlying `FunctionSignatureSyntax` token.
    public struct Signature: Hashable, Equatable {

        // MARK: - Properties
        
        /// The raw syntax node being represented by the instance.
        public let node: FunctionSignatureSyntax

        /// Array of input parameters for the function.
        /// Each parameter is represented by a `Parameter` struct.
        public let input: [Parameter]

        /// The function output type, if any.
        /// This is the return type of the function.
        public let output: EntityType?
        
        /// Bool indicating whether the resolved `output` property is optional.
        ///
        /// For example:
        /// ```swift
        /// func executeOrder() -> String?
        /// func executeOtherOrder() -> String
        /// ```
        /// - The `executeOrder` `output` is `.simple("String?")` and `outputIsOptional` is `true`
        /// - The `executeOtherOrder` `output` is `.simple("String")` and `outputIsOptional` is `false`
        ///
        /// **Note:** Value will be `false` when the `output` is `nil`
        public let outputIsOptional: Bool
        
        /// Will return the raw function return type.
        ///
        /// This can be used when a more accurate string description is needed for the ``Function/Signature/output`` property loses some info.
        /// For example:
        /// ```swift
        /// func example() -> (any SomeProtocol)?
        /// ```
        /// in the above:
        /// - `output` will be `.simple("any SomeProtocol")`
        /// - `outputIsOptional` will be `true`
        /// - The `rawOutputType` will be `"(any SomeProtocol)?"`
        public var rawOutputType: String? {
            node.returnClause?.type.description
        }

        /// The `throws` or `rethrows` keyword, if any.
        /// Indicates whether the function can throw an error.
        @available(
            *,
            deprecated,
            message: "`throwsOrRethrowsKeyword` will be deprecated in 5.0 - Please use `effectSpecifiers.throwsSpecifier` instead"
        )
        public var throwsOrRethrowsKeyword: String? {
            effectSpecifiers?.throwsSpecifier
        }

        /// The `asyncAwait` keyword, if any.
        /// Indicates whether the function supports structured concurrency.
        @available(
            *,
            deprecated,
            message: "`asyncKeyword` will be deprecated in 5.0 - Please use `effectSpecifiers.asyncSpecifier` instead"
        )
        public var asyncKeyword: String? {
            effectSpecifiers?.asyncSpecifier
        }

        /// Struct representing the state of any effect specifiers on the function signature.
        ///
        /// For example, your accessor might support structured concurrency:
        /// ```swift
        /// var name: String {
        ///    func executeOrder66() async throws { ... }
        ///    func performAndWait<T>(_ block: () throws -> T) rethrows -> T
        /// }
        /// ```
        /// in the first function, the `effectSpecifiers` property would be present and output:
        /// - `effectSpecifiers.throwsSpecifier` // `"throws"`
        /// - `effectSpecifiers.asyncAwaitKeyword` // `"async"`
        ///
        /// in the second function, the `effectSpecifiers` property would be present and output:
        /// - `effectSpecifiers.throwsSpecifier` // `"rethrows"`
        /// - `effectSpecifiers.asyncAwaitKeyword` // `nil`
        ///
        /// **Note:** `effectSpecifiers` will be `nil` if no specifiers are found on the node.
        public let effectSpecifiers: EffectSpecifiers?
    }

    // MARK: - Properties: Declaration

    public var node: FunctionDeclSyntax { resolver.node }

    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    public var attributes: [Attribute] { resolver.resolveAttributes() }

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    public var modifiers: [Modifier] { resolver.resolveModifiers() }

    /// The declaration keyword.
    ///
    /// i.e: `"func"` for function declarations.
    public var keyword: String { resolver.resolveKeyword() }

    /// The function identifier (similar to name).
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func performOperation(withName name: String) -> String
    /// ```
    /// - The `identifier` is equal to `performOperation`
    public var identifier: String { resolver.resolveIdentifier() }

    /// Array of generic parameters found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter whose `name` is `"T"` and `type` of `"Equatable"`
    /// ```swift
    /// func performOperation<T: Equatable>(input: T) {}
    /// ```
    public var genericParameters: [GenericParameter] { resolver.resolveGenericParameters() }

    /// Array of generic requirements found in the declaration.
    ///
    /// For example, in the following declaration, there is a single parameter `"T"` whose requirement is that it conforms to `"Hashable"`
    /// ```swift
    /// func performOperation<T>(input: T) where T: Hashable {}
    /// ```
    public var genericRequirements: [GenericRequirement] { resolver.resolveGenericRequirements() }

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
    public var signature: Function.Signature { resolver.resolveSignature() }

    /// Struct representing the body of the function.
    ///
    /// For example in the following declaration:
    /// ```swift
    /// func performOperation() {
    ///     print("hello")
    ///     print("world")
    /// }
    /// ```
    /// would provide a `body` that is not `nil` and would have 2 statements within it.
    public var body: CodeBlock? { resolver.resolveBody() }

    /// `Bool` whether the subscript is a valid operator type.
    public var isOperator: Bool { resolver.resolveIsOperator() }

    /// `Operator.Kind` assigned when the `isOperator` is `true`.
    public var operatorKind: Operator.Kind? { resolver.resolveOperatorKind() }

    /// Returns `true` when the ``Function/Signature/effectSpecifiers`` has the `throw` keyword.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// func example() throws
    /// ```
    public var isThrowing: Bool {
        return signature.effectSpecifiers?.throwsSpecifier != nil
    }

    /// Returns `true` when the ``Function/Signature/effectSpecifiers`` has the `throw` keyword.
    ///
    /// For example, the following would return `true`:
    /// ```swift
    /// func example() async
    /// ```
    public var isAsync: Bool {
        return signature.effectSpecifiers?.asyncSpecifier != nil
    }

    // MARK: - Properties: Resolving

    private(set) var resolver: FunctionSemanticsResolver

    // MARK: - Properties: SyntaxChildCollecting

    // Note: The `CodeBlock` type supports collecting child declarations. The function will default to using that collection.

    public var childCollection: DeclarationCollection {
        body?.childCollection ?? DeclarationCollection()
    }

    // MARK: - Lifecycle

    public init(node: FunctionDeclSyntax) {
        resolver = FunctionSemanticsResolver(node: node)
    }

    // MARK: - Conformance: SyntaxChildCollecting

    public func collectChildren(viewMode: SyntaxTreeViewMode) {
        body?.collectChildren(viewMode: viewMode)
    }
}
