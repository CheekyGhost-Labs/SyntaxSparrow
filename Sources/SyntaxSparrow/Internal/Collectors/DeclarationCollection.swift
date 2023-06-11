//
//  DeclarationCollection.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public final class DeclarationCollection {

    /// The collected class declarations.
    internal(set) public var classes: [Class] = []

    /// The collected conditional compilation block declarations.
    internal(set) public var conditionalCompilationBlocks: [ConditionalCompilationBlock] = []

    /// The collected deinitializer declarations.
    internal(set) public var deinitializers: [Deinitializer] = []

    /// The collected enumeration declarations.
    internal(set) public var enumerations: [Enumeration] = []

    /// The collected extension declarations.
    internal(set) public var extensions: [Extension] = []

    /// The collected function declarations.
    internal(set) public var functions: [Function] = []

    /// The collected import declarations.
    internal(set) public var imports: [Import] = []

    /// The collected initializer declarations.
    internal(set) public var initializers: [Initializer] = []

    /// The collected operator declarations.
    internal(set) public var operators: [Operator] = []

    /// The collected precedence group declarations.
    internal(set) public var precedenceGroups: [PrecedenceGroup] = []

    /// The collected protocol declarations.
    internal(set) public var protocols: [ProtocolDecl] = []

    /// The collected structure declarations.
    internal(set) public var structures: [Structure] = []

    /// The collected subscript declarations.
    internal(set) public var subscripts: [Subscript] = []

    /// The collected type alias declarations.
    internal(set) public var typealiases: [Typealias] = []

    /// The collected internal(set) public variable declarations.
    internal(set) public var variables: [Variable] = []

    func reset() {
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
    }

    func collect(from collection: DeclarationCollection) {
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
    }
}
