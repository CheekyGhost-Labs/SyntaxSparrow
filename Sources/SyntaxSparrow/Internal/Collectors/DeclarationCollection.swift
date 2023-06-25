//
//  DeclarationCollection.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public final class DeclarationCollection {
    /// The collected actor declarations.
    public internal(set) var actors: [Actor] = []

    /// The collected class declarations.
    public internal(set) var classes: [Class] = []

    /// The collected conditional compilation block declarations.
    public internal(set) var conditionalCompilationBlocks: [ConditionalCompilationBlock] = []

    /// The collected deinitializer declarations.
    public internal(set) var deinitializers: [Deinitializer] = []

    /// The collected enumeration declarations.
    public internal(set) var enumerations: [Enumeration] = []

    /// The collected extension declarations.
    public internal(set) var extensions: [Extension] = []

    /// The collected function declarations.
    public internal(set) var functions: [Function] = []

    /// The collected import declarations.
    public internal(set) var imports: [Import] = []

    /// The collected initializer declarations.
    public internal(set) var initializers: [Initializer] = []

    /// The collected operator declarations.
    public internal(set) var operators: [Operator] = []

    /// The collected precedence group declarations.
    public internal(set) var precedenceGroups: [PrecedenceGroup] = []

    /// The collected protocol declarations.
    public internal(set) var protocols: [ProtocolDecl] = []

    /// The collected structure declarations.
    public internal(set) var structures: [Structure] = []

    /// The collected subscript declarations.
    public internal(set) var subscripts: [Subscript] = []

    /// The collected type alias declarations.
    public internal(set) var typealiases: [Typealias] = []

    /// The collected internal(set) public variable declarations.
    public internal(set) var variables: [Variable] = []

    /// The collected switch expression declarations.
    public internal(set) var switches: [SwitchExpression] = []

    func reset() {
        actors = []
        classes = []
        conditionalCompilationBlocks = []
        deinitializers = []
        enumerations = []
        extensions = []
        functions = []
        imports = []
        initializers = []
        operators = []
        precedenceGroups = []
        protocols = []
        structures = []
        subscripts = []
        typealiases = []
        variables = []
        switches = []
    }

    func collect(from collection: DeclarationCollection) {
        actors = collection.actors
        classes = collection.classes
        conditionalCompilationBlocks = collection.conditionalCompilationBlocks
        deinitializers = collection.deinitializers
        enumerations = collection.enumerations
        extensions = collection.extensions
        functions = collection.functions
        imports = collection.imports
        initializers = collection.initializers
        operators = collection.operators
        precedenceGroups = collection.precedenceGroups
        protocols = collection.protocols
        structures = collection.structures
        subscripts = collection.subscripts
        typealiases = collection.typealiases
        variables = collection.variables
        switches = collection.switches
    }
}
