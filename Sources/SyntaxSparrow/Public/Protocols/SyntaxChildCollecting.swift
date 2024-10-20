//
//  DeclarationCollecting.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public protocol SyntaxChildCollecting {
    /// ``SyntaxSparrow/DeclarationCollection`` utility instance any results will be collected into.
    var childCollection: DeclarationCollection { get }

    /// The collected ``Actor`` declarations.
    var actors: [Actor] { get }

    /// The collected ``Class`` declarations.
    var classes: [Class] { get }

    /// The collected ``ConditionalCompilationBlock`` declarations.
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { get }

    /// The collected ``Deinitializer`` declarations.
    var deinitializers: [Deinitializer] { get }

    /// The collected ``Enumeration`` declarations.
    var enumerations: [Enumeration] { get }

    /// The collected ``Extension`` declarations.
    var extensions: [Extension] { get }

    /// The collected ``Function`` declarations.
    var functions: [Function] { get }

    /// The collected ``Import`` declarations.
    var imports: [Import] { get }

    /// The collected ``Initializer`` declarations.
    var initializers: [Initializer] { get }

    /// The collected ``Operator`` declarations.
    var operators: [Operator] { get }

    /// The collected ``PrecedenceGroup`` declarations.
    var precedenceGroups: [PrecedenceGroup] { get }

    /// The collected ``ProtocolDecl`` declarations.
    var protocols: [ProtocolDecl] { get }

    /// The collected ``Structure`` declarations.
    var structures: [Structure] { get }

    /// The collected ``Subscript`` declarations.
    var subscripts: [Subscript] { get }

    /// The collected ``Typealias`` declarations.
    var typealiases: [Typealias] { get }

    /// The collected ``Variable`` declarations.
    var variables: [Variable] { get }

    /// Will reset the collected child instances and re-assess the represented node to collect any supported child declarations.
    /// - Parameter viewMode: The view mode to use when parsing.
    func collectChildren(viewMode: SyntaxTreeViewMode)
}

public extension SyntaxChildCollecting where Self: Declaration {
    var actors: [Actor] { childCollection.actors }
    var classes: [Class] { childCollection.classes }
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { childCollection.conditionalCompilationBlocks }
    var deinitializers: [Deinitializer] { childCollection.deinitializers }
    var enumerations: [Enumeration] { childCollection.enumerations }
    var extensions: [Extension] { childCollection.extensions }
    var functions: [Function] { childCollection.functions }
    var imports: [Import] { childCollection.imports }
    var initializers: [Initializer] { childCollection.initializers }
    var operators: [Operator] { childCollection.operators }
    var precedenceGroups: [PrecedenceGroup] { childCollection.precedenceGroups }
    var protocols: [ProtocolDecl] { childCollection.protocols }
    var structures: [Structure] { childCollection.structures }
    var subscripts: [Subscript] { childCollection.subscripts }
    var typealiases: [Typealias] { childCollection.typealiases }
    var variables: [Variable] { childCollection.variables }
    var switches: [SwitchExpression] { childCollection.switches }

    func collectChildren(viewMode: SyntaxTreeViewMode) {
        let collector = RootDeclarationCollector(viewMode: viewMode)
        let collection = collector.collect(fromNode: node)
        childCollection.collect(from: collection)
    }
}

public extension SyntaxChildCollecting where Self: DeclarationComponent {
    var actors: [Actor] { childCollection.actors }
    var classes: [Class] { childCollection.classes }
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { childCollection.conditionalCompilationBlocks }
    var deinitializers: [Deinitializer] { childCollection.deinitializers }
    var enumerations: [Enumeration] { childCollection.enumerations }
    var extensions: [Extension] { childCollection.extensions }
    var functions: [Function] { childCollection.functions }
    var imports: [Import] { childCollection.imports }
    var initializers: [Initializer] { childCollection.initializers }
    var operators: [Operator] { childCollection.operators }
    var precedenceGroups: [PrecedenceGroup] { childCollection.precedenceGroups }
    var protocols: [ProtocolDecl] { childCollection.protocols }
    var structures: [Structure] { childCollection.structures }
    var subscripts: [Subscript] { childCollection.subscripts }
    var typealiases: [Typealias] { childCollection.typealiases }
    var variables: [Variable] { childCollection.variables }

    func collectChildren(viewMode: SyntaxTreeViewMode) {
        let collector = RootDeclarationCollector(viewMode: viewMode)
        let collection = collector.collect(fromNode: node)
        childCollection.collect(from: collection)
    }
}

public extension SyntaxChildCollecting {
    
    /// Will recursively iterate through the collected declarations **on the current declaration** for the given type and return them in a flattened array.
    ///
    /// Note: Declarations are returned **in order of declaration**
    ///
    /// For example,
    /// ```swift
    /// enum Container {
    ///    struct NestedStruct {
    ///        struct NestedStructTwo {
    ///            enum NestedContainer {}
    ///        }
    ///    }
    /// }
    /// struct RootLevelStruct {}
    /// ```
    /// If you invoke the `recursivelyCollectDeclarations(Structure.self)` helper on the root `SyntaxTree` instance would return:
    /// - [`Structure<NesedStruct>`, `Structure<NestedStructTwo>`, `Structure<RootLevelStruct>`]
    /// if you invoke the helper on the `tree.enumerations[0]` instance would return:
    /// - [`Structure<NesedStruct>`, `Structure<NestedStructTwo>`]
    ///
    /// - Parameter type: The type to collect
    /// - Returns: Array of the inferred `Declaration` type
    func recursivelyCollectDeclarations<T: Declaration>(of type: T.Type) -> [T] {
        let rootLevels = childDeclarations(of: type, from: self)
        let targets = syntaxChildCollectingDeclarations(from: self)
        //let rootLevels = targets.flatMap { childDeclarations(of: type, from: $0) }
        let nested = targets.flatMap { $0.recursivelyCollectDeclarations(of: type) }
        let results = (rootLevels + nested).sorted(by: { $0.node.position.utf8Offset < $1.node.position.utf8Offset })
        return results
    }

    // MARK: - Helpers: Private

    private func syntaxChildCollectingDeclarations(from childCollecting: SyntaxChildCollecting) -> [SyntaxChildCollecting] {
        var targets: [any SyntaxChildCollecting] = []
        targets.append(contentsOf: childCollecting.actors)
        targets.append(contentsOf: childCollecting.classes)
        let branches = childCollecting.conditionalCompilationBlocks.flatMap(\.branches)
        targets.append(contentsOf: branches)
        targets.append(contentsOf: childCollecting.deinitializers)
        targets.append(contentsOf: childCollecting.enumerations)
        targets.append(contentsOf: childCollecting.extensions)
        targets.append(contentsOf: childCollecting.functions)
        targets.append(contentsOf: childCollecting.initializers)
        targets.append(contentsOf: childCollecting.protocols)
        targets.append(contentsOf: childCollecting.structures)
        // accessors
        let subscriptAccessors = childCollecting.subscripts.flatMap(\.accessors)
        targets.append(contentsOf: subscriptAccessors)
        let variableAccessors = childCollecting.variables.flatMap(\.accessors)
        targets.append(contentsOf: variableAccessors)
        return targets
    }

    private func childDeclarations<T: Declaration>(of type: T.Type, from childCollecting: SyntaxChildCollecting) -> [T] {
        var result: [Any] = []
        switch type {
        case is Actor.Type:
            result = childCollecting.actors
        case is Class.Type:
            result = childCollecting.classes
        case is ConditionalCompilationBlock.Type:
            result = childCollecting.conditionalCompilationBlocks
        case is Deinitializer.Type:
            result = childCollecting.deinitializers
        case is Enumeration.Type:
            result = childCollecting.enumerations
        case is Extension.Type:
            result = childCollecting.extensions
        case is Function.Type:
            result = childCollecting.functions
        case is Import.Type:
            result = childCollecting.imports
        case is Initializer.Type:
            result = childCollecting.initializers
        case is Operator.Type:
            result = childCollecting.operators
        case is PrecedenceGroup.Type:
            result = childCollecting.precedenceGroups
        case is ProtocolDecl.Type:
            result = childCollecting.protocols
        case is Structure.Type:
            result = childCollecting.structures
        case is Subscript.Type:
            result = childCollecting.subscripts
        case is Typealias.Type:
            result = childCollecting.typealiases
        case is Variable.Type:
            result = childCollecting.variables
        default:
            break
        }
        return (result as? [T]) ?? []
    }
}
