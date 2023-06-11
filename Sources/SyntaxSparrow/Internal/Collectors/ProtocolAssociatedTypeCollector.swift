//
//  ProtocolAssociatedTypeCollector.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// `SkipByDefaultVisitor` subclass that collects `AssociatedType` declarations from within a `ProtocolDeclSyntax`.
/// For the most part, this means traversing the nested `MemberDeclBlockSyntax`, `MemberDeclListSyntax`, and `MemberDeclListItemSyntax`
/// for the desired `AssociatedtypeDeclSyntax` types and processing them as normal.
///
/// As this is based on current swift-syntax behavior, the expectation is that visiting the expected node children will resolve to the expected types.
///
/// This collector allows visiting down this expected path and captures any resolved `associatedType` by token identifier kinds.
/// Results are collected into an array for post-processing.
class ProtocolAssociatedTypeCollector: SkipByDefaultVisitor {
    // MARK: - Properties

    /// Private array for holding any results. This is emptied when invoking the `collect(from:)` method.
    private var results: [AssociatedType] = []

    // MARK: - Helpers

    @discardableResult
    func collect(from node: ProtocolDeclSyntax) -> [AssociatedType] {
        results.removeAll()
        walk(node)
        return results
    }

    private func isAssociatedTypeToken(_ node: TokenSyntax?) -> Bool {
        guard let node = node, node.tokenKind == .identifier("associatedType") else { return false }
        return true
    }

    // MARK: - Overrides

    override func visit(_: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_: MemberDeclBlockSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_: MemberDeclListSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_: MemberDeclListItemSyntax) -> SyntaxVisitorContinueKind {
        return .visitChildren
    }

    override func visit(_ node: AssociatedtypeDeclSyntax) -> SyntaxVisitorContinueKind {
        let declaration = AssociatedType(node: node)
        results.append(declaration)
        return .skipChildren
    }
}
