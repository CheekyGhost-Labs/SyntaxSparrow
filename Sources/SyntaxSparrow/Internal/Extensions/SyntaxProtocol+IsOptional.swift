//
//  SyntaxProtocol+IsOptional.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

extension SyntaxProtocol {

    /// Will asses the current `SyntaxProtocol` node without type context (i.e not `TypeSyntaxProtocol`) and perform a parent based assessment to resolve if
    /// the node is within an `OptionalTypeSyntax`. If there is no parent `OptionalTypeSyntax` (possible in some cases) the `nextToken` will be iterated until
    /// the parent node is exited, or an optional token found.
    /// - Parameter viewMode: The `SyntaxTreeViewMode` to use when parsing children.
    /// - Returns: `Bool`
    func resolveIsSyntaxOptional(viewMode: SyntaxTreeViewMode = .fixedUp) -> Bool {
        guard self.as(OptionalTypeSyntax.self) == nil else { return true }
        guard parent?.as(OptionalTypeSyntax.self) == nil else { return true }
        if let parent = parent?.as(TypeAnnotationSyntax.self) {
            return parent.type.as(OptionalTypeSyntax.self) != nil
        } else if let tupleElement = self.as(TupleTypeElementSyntax.self) {
            return tupleElement.type.as(OptionalTypeSyntax.self) != nil
        } else if let generic = self.as(GenericArgumentSyntax.self) {
            return generic.argument.as(OptionalTypeSyntax.self) != nil
        }
        return false
    }
}
