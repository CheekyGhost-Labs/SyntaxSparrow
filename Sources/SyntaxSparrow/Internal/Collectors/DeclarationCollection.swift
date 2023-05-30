//
//  DeclarationCollection.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

struct DeclarationCollection {

    /// The collected class declarations.
    var classes: [Class] = []

    /// The collected conditional compilation block declarations.
    var conditionalCompilationBlocks: [ConditionalCompilationBlock] = []

    /// The collected deinitializer declarations.
    var deinitializers: [Deinitializer] = []

    /// The collected enumeration declarations.
    var enumerations: [Enumeration] = []

    /// The collected extension declarations.
    var extensions: [Extension] = []

    /// The collected function declarations.
    var functions: [Function] = []

    /// The collected import declarations.
    var imports: [Import] = []

    /// The collected initializer declarations.
    var initializers: [Initializer] = []

    /// The collected operator declarations.
    var operators: [Operator] = []

    /// The collected precedence group declarations.
    var precedenceGroups: [PrecedenceGroup] = []

    /// The collected protocol declarations.
    var protocols: [`Protocol`] = []

    /// The collected structure declarations.
    var structures: [Structure] = []

    /// The collected subscript declarations.
    var subscripts: [Subscript] = []

    /// The collected type alias declarations.
    var typealiases: [Typealias] = []

    /// The collected variable declarations.
    var variables: [Variable] = []
}
