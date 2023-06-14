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

    /// The collected class declarations.
    var classes: [Class] { get }

    /// The collected conditional compilation block declarations.
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { get }

    /// The collected deinitializer declarations.
    var deinitializers: [Deinitializer] { get }

    /// The collected enumeration declarations.
    var enumerations: [Enumeration] { get }

    /// The collected extension declarations.
    var extensions: [Extension] { get }

    /// The collected function declarations.
    var functions: [Function] { get }

    /// The collected import declarations.
    var imports: [Import] { get }

    /// The collected initializer declarations.
    var initializers: [Initializer] { get }

    /// The collected operator declarations.
    var operators: [Operator] { get }

    /// The collected precedence group declarations.
    var precedenceGroups: [PrecedenceGroup] { get }

    /// The collected protocol declarations.
    var protocols: [ProtocolDecl] { get }

    /// The collected structure declarations.
    var structures: [Structure] { get }

    /// The collected subscript declarations.
    var subscripts: [Subscript] { get }

    /// The collected type alias declarations.
    var typealiases: [Typealias] { get }

    /// The collected variable declarations.
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

    func collectChildren(viewMode: SyntaxTreeViewMode) {
        let collector = RootDeclarationCollector(viewMode: viewMode)
        let collection = collector.collect(fromNode: node)
        childCollection.collect(from: collection)
    }
}
