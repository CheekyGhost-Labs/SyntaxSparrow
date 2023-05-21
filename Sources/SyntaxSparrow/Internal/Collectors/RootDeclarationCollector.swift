//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax
import SwiftSyntaxParser

/// A class responsible for collecting declarations, such as `Structure`, `Class`, `Enumeration`, `Function`, etc., from a node.
/// The collector will impose a (configurable) limit on how deep to traverse from the provided node since the declaration types will support the `SyntaxExploring` protocol
/// and utilize another `RootDeclarationCollector` instance to collect their child declarations.
class RootDeclarationCollector: SyntaxVisitor {

    // MARK: - Properties

    /// `DeclarationCollection` instance to collect results into.
    private(set) var collection: DeclarationCollection = DeclarationCollection()

    /// `SyntaxExplorerContext` instance holding root collection details and instances. This context will be shared with any child elements that require lazy evaluation or collection
    /// as needed. It is `Actor` based to ensure thread safety.
    public let context: SyntaxExplorerContext

    /// Transient entry node used when walking over a node. The entry node will be ignored and it's children visited.
    private(set) var entryNode: SyntaxProtocol?

    // MARK: - Lifecycle

    required init(context: SyntaxExplorerContext) {
        self.context = context
        super.init(viewMode: context.viewMode)
    }

    // MARK: - Helpers

    /// Will walk through the syntax as normal but use the provided source buffer to resolve what start/end lines a declaration is on.
    ///
    /// **Note:** If the standard `walk(_:)` method is used **all lines will be 0**
    /// - Parameter source: The source code being analyzed by this instance.
    @discardableResult func collect(fromSource source: String) throws -> DeclarationCollection {
        collection = DeclarationCollection()
        let tree = try SyntaxParser.parse(source: source)
        if context.sourceLocationConverter.isEmpty {
            context.sourceLocationConverter.updateForTree(tree)
        }
        walk(tree)
        return collection
    }

    /// Will walk through the syntax as normal but use the provided source buffer to resolve what start/end lines a declaration is on.
    ///
    /// **Note:** If the standard `walk(_:)` method is used **all lines will be 0**
    /// - Parameter node: The node to traverse
    @discardableResult func collect(fromNode node: SyntaxProtocol) -> DeclarationCollection {
        entryNode = node
        collection.clear()
        if context.sourceLocationConverter.isEmpty {
            context.sourceLocationConverter.updateToRootForNode(node)
        }
        walk(node)
        return collection
    }

    // MARK: - Overrides: SyntaxVisitor

    /// Called when visiting an `AssociatedtypeDeclSyntax` node
    override func visit(_ node: AssociatedtypeDeclSyntax) -> SyntaxVisitorContinueKind {
        // AssociatedType
        // Track token ref
        return .skipChildren
    }

    /// Called when visiting a `ClassDeclSyntax` node
    override func visit(_ node: ClassDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Class(node: node, context: context)
        collection.classes.append(declaration)
        declaration.collectChildren()
        return .skipChildren
    }

    /// Called when visiting a `DeinitializerDeclSyntax` node
    override func visit(_ node: DeinitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Deinitializer(node: node, context: context)
        collection.deinitializers.append(declaration)
        return .skipChildren
    }

    /// Called when visiting an `EnumDeclSyntax` node
    override func visit(_ node: EnumDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Enumeration(node: node, context: context)
        collection.enumerations.append(declaration)
        declaration.collectChildren()
        return .skipChildren
    }

    /// Called when visiting an `EnumCaseDeclSyntax` node
    override func visit(_ node: EnumCaseDeclSyntax) -> SyntaxVisitorContinueKind {
        return .skipChildren
    }

    /// Called when visiting an `ExtensionDeclSyntax` node
    override func visit(_ node: ExtensionDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Extension(node: node, context: context)
        collection.extensions.append(declaration)
        declaration.collectChildren()
        return .skipChildren
    }

    /// Called when visiting a `FunctionDeclSyntax` node
    override func visit(_ node: FunctionDeclSyntax) -> SyntaxVisitorContinueKind {
        // Function
        return .skipChildren
    }

    /// Called when visiting an `IfConfigDeclSyntax` node
    override func visit(_ node: IfConfigDeclSyntax) -> SyntaxVisitorContinueKind {
        // if configuration
        return .skipChildren
    }

    /// Called when visiting an `ImportDeclSyntax` node
    override func visit(_ node: ImportDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Import(node: node, context: context)
        collection.imports.append(declaration)
        return .skipChildren
    }

    /// Called when visiting an `InitializerDeclSyntax` node
    override func visit(_ node: InitializerDeclSyntax) -> SyntaxVisitorContinueKind {
        // initializer
        return .skipChildren
    }

    /// Called when visiting an `OperatorDeclSyntax` node
    override func visit(_ node: OperatorDeclSyntax) -> SyntaxVisitorContinueKind {
        // operator
        return .skipChildren
    }

    /// Called when visiting a `PrecedenceGroupDeclSyntax` node
    override func visit(_ node: PrecedenceGroupDeclSyntax) -> SyntaxVisitorContinueKind {
        // Precedence group
        return .skipChildren
    }

    /// Called when visiting a `ProtocolDeclSyntax` node
    override func visit(_ node: ProtocolDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Protocol(node: node, context: context)
        collection.protocols.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `SubscriptDeclSyntax` node
    override  func visit(_ node: SubscriptDeclSyntax) -> SyntaxVisitorContinueKind {
        // subscript
        return .skipChildren
    }

    /// Called when visiting a `StructDeclSyntax` node
    override func visit(_ node: StructDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Structure(node: node, context: context)
        collection.structures.append(declaration)
        declaration.collectChildren()
        return .skipChildren
    }

    /// Called when visiting a `TypealiasDeclSyntax` node
    override func visit(_ node: TypealiasDeclSyntax) -> SyntaxVisitorContinueKind {
        if let entryNode = entryNode, node.id == entryNode.id { return .visitChildren }
        let declaration = Typealias(node: node, context: context)
        collection.typealiases.append(declaration)
        return .skipChildren
    }

    /// Called when visiting a `VariableDeclSyntax` node
    override func visit(_ node: VariableDeclSyntax) -> SyntaxVisitorContinueKind {
        // variable
        return .skipChildren
    }
}
