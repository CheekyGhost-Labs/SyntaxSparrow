//
//  ConditionalCompilationBlock.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `ConditionalCompilationBlock` is a struct representing a Swift conditional compilation block declaration. This struct is part of the SyntaxSparrow library, which provides an
/// interface for traversing and extracting information from Swift source code.
///
/// This class provides a detailed breakdown of a structure declaration, including its name, attributes, modifiers, inheritance, and generic parameters and requirements.
/// Each instance of `Function` corresponds to a `FunctionDeclSyntax` node in the Swift syntax tree.
///
/// `Structure` supports conformance to protocols such as `Equatable`, `Hashable`, `CustomStringConvertible`, and `CustomDebugStringConvertible`
/// for easy comparison, hashing, and debugging.
///
/// The location of the structure in the source code is captured in `startLocation` and `endLocation` properties.
public struct ConditionalCompilationBlock: Declaration, SyntaxSourceLocationResolving {

    // MARK: - Properties: SyntaxSourceLocationResolving

    public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

    // MARK: - Properties: DeclarationCollecting

    private(set) var resolver: ConditionalCompilationBlockSemanticsResolver

    // MARK: - Lifecycle

    public init(node: IfConfigDeclSyntax, context: SyntaxExplorerContext) {
        self.resolver = ConditionalCompilationBlockSemanticsResolver(node: node, context: context)
    }

    // MARK: - Properties: Child Collection

    func collectChildren() {
        // no-op
    }

    // MARK: - Equatable

    public static func == (lhs: ConditionalCompilationBlock, rhs: ConditionalCompilationBlock) -> Bool {
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

    /**
     The conditional compilation block branches.

     For example,
     the following compilation block declaration has two branches:

     ```swift
     #if true
     enum A {}
     #else
     enum B {}
     #endif
     ```

     The first branch has the keyword `#if` and condition `"true"`.
     The second branch has the keyword `#else` and no condition.
     */
    public let branches: [Branch] = []

    /// A conditional compilation block branch.
//    public
}

public extension ConditionalCompilationBlock {

    enum Branch {
        /// An `#if` branch.
        case `if`(String)

        /// An `#elseif` branch.
        case `elseif`(String)

        /// An `#else` branch.
        case `else`

        init?(keyword: String, condition: String?) {
            switch (keyword, condition) {
            case let ("#if", condition?):
                self = .if(condition)
            case let ("#elseif", condition?):
                self = .elseif(condition)
            case ("#else", nil):
                self = .else
            default:
                return nil
            }
        }

        /// The branch keyword, either `"#if"`, `"#elseif"`, or `"#else"`.
        public var keyword: String {
            switch self {
            case .if:
                return "#if"
            case .elseif:
                return "#elseif"
            case .else:
                return "#else"
            }
        }

        /**
         The branch condition, if any.

         This value is present when `keyword` is equal to `"#if"` or `#elseif`
         and `nil` when `keyword` is  equal to `"#else"`.
         */
        public var condition: String? {
            switch self {
            case let .if(condition),
                 let .elseif(condition):
                return condition
            case .else:
                return nil
            }
        }
    }
}
