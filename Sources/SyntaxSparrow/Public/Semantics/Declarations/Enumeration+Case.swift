//
//  Enumeration+Case.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension Enumeration {

    /// Represents a case in a Swift enumeration declaration.
    ///
    /// Cases are distinct values that an enumeration can represent.
    /// Each case can have associated values or a raw value.
    ///
    /// Each instance of ``SyntaxSparrow/Enumeration/Case`` corresponds to an `EnumCaseElementSyntax` node in the Swift syntax tree.
    ///
    /// This structure conforms to `Declaration` and `SyntaxSourceLocationResolving`,
    /// which provide access to the declaration attributes, modifiers, and source location information.
    public struct Case: Declaration, SyntaxSourceLocationResolving {
        /// Array of attributes found in the declaration.
        ///
        /// - See: ``SyntaxSparrow/Attribute``
        public var attributes: [Attribute] { resolver.attributes }

        /// Array of modifiers found in the declaration.
        /// - See: ``SyntaxSparrow/Modifier``
        public var modifiers: [Modifier] { resolver.modifiers }

        /// The declaration keyword.
        ///
        /// i.e: `"enum"`
        public var keyword: String { resolver.keyword }

        /// The structure name.
        ///
        /// i.e: `enum MyEnum { ... }` would have a name of `"MyEnum"`
        /// If the structure is unnamed, this will be an empty string.
        public var name: String { resolver.name }

        /// The associated values of the enumeration case, if any.
        public var associatedValues: [Parameter]? { resolver.associatedValues }

        /// The raw value of the enumeration case, if any.
        public var rawValue: String? { resolver.rawValue }

        // MARK: - Properties: SyntaxSourceLocationResolving

        public var sourceLocation: SyntaxSourceLocation { resolver.sourceLocation }

        // MARK: - Properties: DeclarationCollecting

        private(set) var resolver: EnumerationCaseSemanticsResolver

        // MARK: - Lifecycle

        /// Creates a new ``SyntaxSparrow/Enumeration/Case`` instance from an `EnumCaseElementSyntax` node.
        public init(node: EnumCaseElementSyntax, context: SyntaxExplorerContext) {
            self.resolver = EnumerationCaseSemanticsResolver(node: node, context: context)
        }

        // MARK: - Equatable

        public static func == (lhs: Case, rhs: Case) -> Bool {
            return lhs.description == rhs.description
        }

        // MARK: - Hashable

        public func hash(into hasher: inout Hasher) {
            return hasher.combine(description.hashValue)
        }

        // MARK: - CustomStringConvertible

        public var description: String {
            guard let parent = resolver.node.context as? EnumCaseDeclSyntax else {
                return resolver.node.description.trimmed
            }
            return parent.description.trimmed
        }
    }
}
