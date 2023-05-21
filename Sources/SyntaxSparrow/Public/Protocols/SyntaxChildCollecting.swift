//
//  DeclarationCollecting.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public protocol SyntaxChildCollecting {
    //    /// The collected associated type declarations.
    //    var associatedTypes: [AssociatedType] { get }
    //
    /// The collected class declarations.
    var classes: [Class] { get }
    //
    //    /// The collected conditional compilation block declarations.
    //    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { get }

    /// The collected deinitializer declarations.
    var deinitializers: [Deinitializer] { get }

    /// The collected enumeration declarations.
    var enumerations: [Enumeration] { get }
    //
    //    /// The collected enumeration case declarations.
    //    var enumerationCases: [Enumeration.Case] { get }
    //
    //    /// The collected extension declarations.
    //    var extensions: [Extension] { get }
    //
    //    /// The collected function declarations.
    //    var functions: [Function] { get }
    //
    //    /// The collected import declarations.
    //    var imports: [Import] { get }
    //
    //    /// The collected initializer declarations.
    //    var initializers: [Initializer] { get }
    //
    //    /// The collected operator declarations.
    //    var operators: [Operator] { get }
    //
    //    /// The collected precedence group declarations.
    //    var precedenceGroups: [PrecedenceGroup] { get }
    //
    /// The collected protocol declarations.
    var protocols: [Protocol] { get }

    /// The collected structure declarations.
    var structures: [Structure] { get }

    //    /// The collected subscript declarations.
    //    var subscripts: [Subscript] { get }
    //
    //    /// The collected type alias declarations.
    //    var typealiases: [Typealias] { get }
    //
    //    /// The collected variable declarations.
    //    var variables: [Variable] { get }
}
