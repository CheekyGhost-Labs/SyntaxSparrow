//
//  PrecedenceGroupSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming struct that is responsible for exploring, retrieving properties, and collecting children of a
/// `PrecedenceGroupDeclSyntax` node.
/// It exposes the expected properties of a `Protocol` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
struct PrecedenceGroupSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = PrecedenceGroupDeclSyntax

    let node: Node

    // MARK: - Lifecycle

    init(node: PrecedenceGroupDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    func resolveName() -> String {
        node.identifier.text.trimmed
    }

    func resolveKeyword() -> String {
        node.precedencegroupKeyword.text.trimmed
    }

    func resolveAssignment() -> Bool? {
        for attribute in node.groupAttributes {
            if let assignmentSyntax = attribute.as(PrecedenceGroupAssignmentSyntax.self) {
                return Bool(assignmentSyntax.flag.text.trimmed)
            }
        }
        return nil
    }

    func resolveAssociativity() -> PrecedenceGroup.Associativity? {
        for attribute in node.groupAttributes {
            if let associativitySyntax = attribute.as(PrecedenceGroupAssociativitySyntax.self) {
                return PrecedenceGroup.Associativity(rawValue: associativitySyntax.value.text.trimmed)
            }
        }
        return nil
    }

    func resolveRelations() -> [PrecedenceGroup.Relation] {
        let relations = node.groupAttributes.compactMap { PrecedenceGroupRelationSyntax($0) }
        let mapped: [PrecedenceGroup.Relation] = relations.compactMap {
            let otherNames = $0.otherNames.map(\.name.description)
            switch $0.higherThanOrLowerThan.text {
            case "higherThan":
                return .higherThan(otherNames)
            case "lowerThan":
                return .lowerThan(otherNames)
            default:
                return nil
            }
        }
        return mapped
    }
}
