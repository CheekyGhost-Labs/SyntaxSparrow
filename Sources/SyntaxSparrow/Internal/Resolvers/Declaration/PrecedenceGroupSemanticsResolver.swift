//
//  PrecedenceGroupSemanticsResolver.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `DeclarationSemanticsResolving` conforming class that is responsible for exploring, retrieving properties, and collecting children of a
/// `PrecedenceGroupDeclSyntax` node.
/// It exposes the expected properties of a `Protocol` as `lazy` properties. This will allow the initial lazy evaluation to not be repeated when
/// accessed repeatedly.
class PrecedenceGroupSemanticsResolver: SemanticsResolving {
    // MARK: - Properties: SemanticsResolving

    typealias Node = PrecedenceGroupDeclSyntax

    let node: Node

    private(set) var declarationCollection: DeclarationCollection = .init()

    // MARK: - Properties: StructureDeclaration

    private(set) lazy var keyword: String = resolveKeyword()

    private(set) lazy var name: String = resolveName()

    private(set) lazy var assignment: Bool? = resolveAssignment()

    private(set) lazy var associativity: PrecedenceGroup.Associativity? = resolveAssociativity()

    private(set) lazy var relations: [PrecedenceGroup.Relation] = resolveRelations()

    // MARK: - Lifecycle

    required init(node: PrecedenceGroupDeclSyntax) {
        self.node = node
    }

    // MARK: - Resolvers

    private func resolveName() -> String {
        node.identifier.text.trimmed
    }

    private func resolveKeyword() -> String {
        node.precedencegroupKeyword.text.trimmed
    }

    private func resolveAssignment() -> Bool? {
        for attribute in node.groupAttributes {
            if let assignmentSyntax = attribute.as(PrecedenceGroupAssignmentSyntax.self) {
                return Bool(assignmentSyntax.flag.text.trimmed)
            }
        }
        return nil
    }

    private func resolveAssociativity() -> PrecedenceGroup.Associativity? {
        for attribute in node.groupAttributes {
            if let associativitySyntax = attribute.as(PrecedenceGroupAssociativitySyntax.self) {
                return PrecedenceGroup.Associativity(rawValue: associativitySyntax.value.text.trimmed)
            }
        }
        return nil
    }

    private func resolveRelations() -> [PrecedenceGroup.Relation] {
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
