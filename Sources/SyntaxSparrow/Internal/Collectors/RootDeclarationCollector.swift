//
//  RootDeclarationCollector.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftParser
import SwiftSyntax

/// A class responsible for collecting declarations, such as `Structure`, `Class`, `Enumeration`, `Function`, etc., from a node.
/// The collector will impose a (configurable) limit on how deep to traverse from the provided node since the declaration types will support the
/// `SyntaxExploring` protocol
/// and utilize another `RootDeclarationCollector` instance to collect their child declarations.
class RootDeclarationCollector: SyntaxVisitor {
    // MARK: - Properties

    /// `DeclarationCollection` instance to collect results into.
    private(set) var declarationCollection: DeclarationCollection = .init()

    /// Transient entry node used when walking over a node. The entry node will be ignored and it's children visited.
    private(set) var entryNode: SyntaxProtocol?

    // MARK: - Helpers

    /// Will walk through the syntax as normal but use the provided source buffer to resolve what start/end lines a declaration is on.
    ///
    /// **Note:** If the standard `walk(_:)` method is used **all lines will be 0**
    /// - Parameter source: The source code being analyzed by this instance.
    @discardableResult func collect(fromSource source: String) -> DeclarationCollection {
        declarationCollection.reset()
        let tree = Parser.parse(source: source)
        walk(tree)
        return declarationCollection
    }

    /// Will walk through the syntax as normal but use the provided source buffer to resolve what start/end lines a declaration is on.
    ///
    /// **Note:** If the standard `walk(_:)` method is used **all lines will be 0**
    /// - Parameter node: The node to traverse
    @discardableResult func collect(fromNode node: SyntaxProtocol) -> DeclarationCollection {
        entryNode = node
        declarationCollection.reset()
        walk(node)
        return declarationCollection
    }

    // MARK: - Overrides: SyntaxVisitor

    /// Called when visiting an `AssociatedtypeDeclSyntax` node
    override func visit(_: AssociatedtypeDeclSyntax) -> SyntaxVisitorContinueKind {
        // Associated types are only valid within protocols - the protocol type collects these as needed
        return .skipChildren
    }

    override func visit(_ node: ActorDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Actor(node: node)
        declarationCollection.actors.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting a `ClassDeclSyntax` node
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Class(node: node)
        declarationCollection.classes.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting a `DeinitializerDeclSyntax` node
    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Deinitializer(node: node)
        declarationCollection.deinitializers.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting an `EnumDeclSyntax` node
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Enumeration(node: node)
        declarationCollection.enumerations.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting an `EnumCaseDeclSyntax` node
    override func visit(_: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    /// Called when visiting an `ExtensionDeclSyntax` node
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Extension(node: node)
        declarationCollection.extensions.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting a `FunctionDeclSyntax` node
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Function(node: node)
        declarationCollection.functions.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting an `IfConfigDeclSyntax` node
    override func visit(_ node: IfConfigDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = ConditionalCompilationBlock(node: node)
        declarationCollection.conditionalCompilationBlocks.append(declaration)
        declaration.branches.forEach { $0.collectChildren(viewMode: viewMode) }
        return .skipChildren
    }

    /// Called when visiting an `ImportDeclSyntax` node
    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Import(node: node)
        declarationCollection.imports.append(declaration)
        return .skipChildren
    }

    /// Called when visiting an `InitializerDeclSyntax` node
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Initializer(node: node)
        declarationCollection.initializers.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting an `OperatorDeclSyntax` node
    override func visit(_ node: OperatorDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Operator(node: node)
        declarationCollection.operators.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `PrecedenceGroupDeclSyntax` node
    override func visit(_ node: PrecedenceGroupDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = PrecedenceGroup(node: node)
        declarationCollection.precedenceGroups.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `ProtocolDeclSyntax` node
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = ProtocolDecl(node: node)
        declaration.resolver.viewMode = viewMode
        declarationCollection.protocols.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting a `SubscriptDeclSyntax` node
    override func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Subscript(node: node)
        declarationCollection.subscripts.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `StructDeclSyntax` node
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Structure(node: node)
        declarationCollection.structures.append(declaration)
        declaration.collectChildren(viewMode: viewMode)
        return .skipChildren
    }

    /// Called when visiting a `TypealiasDeclSyntax` node
    override func visit(_ node: TypealiasDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Typealias(node: node)
        declarationCollection.typealiases.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `VariableDeclSyntax` node
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declarations = Variable.variables(from: node)
        declarationCollection.variables.append(contentsOf: declarations)
        return .skipChildren
    }

    override func visit(_ node: PatternBindingSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Variable(node: node)
        declarationCollection.variables.append(declaration)
        return .visitChildren
    }
}
