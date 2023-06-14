//
//  File.swift
//  
//
//  Created by Michael O'Brien on 14/6/2023.
//

import Foundation
import SwiftSyntax

public extension Accessor {

    struct EffectSpecifiers: DeclarationComponent {

        // MARK: - Properties: DeclarationComponent

        public let node: AccessorEffectSpecifiersSyntax

        // MARK: - Properties

        /// The `throws` keyword, if any.
        /// Indicates whether the function can throw an error.
        public let throwsSpecifier: String?

        /// The `asyncSpecifier` specifier, if any.
        /// Indicates whether the function supports structured concurrency.
        public let asyncSpecifier: String?

        // MARK: - Lifecycle

        /// Creates a new ``SyntaxSparrow/Accessor/Effect`` instance from an `AccessorEffectSpecifiersSyntax` node.
        public init(node: AccessorEffectSpecifiersSyntax) {
            self.node = node
            throwsSpecifier = node.throwsSpecifier?.text.trimmed
            asyncSpecifier = node.asyncSpecifier?.text.trimmed
        }
    }
}
