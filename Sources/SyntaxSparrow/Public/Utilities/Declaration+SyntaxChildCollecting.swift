//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension Declaration where Self: SyntaxChildCollecting {
//    var associatedTypes: [AssociatedType] { collection?.associatedTypes ?? [] }
    var classes: [Class] { collection?.classes ?? [] }
//    var conditionalCompilationBlocks: [ConditionalCompilationBlock] { collection?.conditionalCompilationBlocks ?? [] }
    var deinitializers: [Deinitializer] { collection?.deinitializers ?? [] }
    var enumerations: [Enumeration] { collection?.enumerations ?? [] }
//    var enumerationCases: [Enumeration.Case] { collection?.enumerationCases ?? [] }
    var extensions: [Extension] { collection?.extensions ?? [] }
//    var functions: [Function] { collection?.functions ?? [] }
    var imports: [Import] { collection?.imports ?? [] }
//    var initializers: [Initializer] { collection?.initializers ?? [] }
//    var operators: [Operator] { collection?.operators ?? [] }
//    var precedenceGroups: [PrecedenceGroup] { collection?.precedenceGroups ?? [] }
    var protocols: [`Protocol`] { collection?.protocols ?? [] }
    var structures: [Structure] { collection?.structures ?? [] }
//    var subscripts: [Subscript] { collection?.subscripts ?? [] }
    var typealiases: [Typealias] { collection?.typealiases ?? [] }
//    var variables: [Variable] { collection?.variables ?? [] }
}
