//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public extension SyntaxTree {

    /// Will assess and process the source at the given path and resolve an array containing instances of the provided declaration type.
    /// - Parameters:
    ///   - type: The ``SyntaxSparrow/Declaration`` conforming type to parse into.
    ///   - path: The file path for the raw source code.
    ///   - viewMode: The view mode to use when iterating children or related parsing processes
    /// - Returns: Array containing any instances matching the `T` constraint
    static func declarations<T: Declaration>(
        of type: T.Type,
        inSourceAtPath path: String,
        viewMode: SyntaxTreeViewMode = .fixedUp
    ) throws -> [T] {
        let instance = try SyntaxTree(viewMode: viewMode, sourceAtPath: path)
        instance.collectChildren()
        return instance.declarations(of: type)
    }

    /// Will assess and process the given source and resolve an array containing instances of the provided declaration type.
    /// - Parameters:
    ///   - type: The ``SyntaxSparrow/Declaration`` conforming type to parse into.
    ///   - source: The raw source code to parse.
    ///   - viewMode: The view mode to use when iterating children or related parsing processes
    /// - Returns: Array containing any instances matching the `T` constraint
    static func declarations<T: Declaration>(
        of type: T.Type,
        inSource source: String,
        viewMode: SyntaxTreeViewMode = .fixedUp
    ) -> [T] {
        let instance = SyntaxTree(viewMode: viewMode, sourceBuffer: source)
        instance.collectChildren()
        return instance.declarations(of: type)
    }
    
    /// Will assess and process the given declaration syntax protocol and convert it into the provided declaration type (if possible).
    /// - Parameters:
    ///   - type: The ``SyntaxSparrow/Declaration`` conforming type to parse into.
    ///   - declarationSyntax: The raw `DeclSyntaxProtocol` from `SwiftSyntax`
    ///   - viewMode: The view mode to use when iterating children or related parsing processes
    /// - Returns: `T` or `nil`
    static func declaration<T: Declaration>(
        of type: T.Type,
        fromSyntax declarationSyntax: DeclSyntaxProtocol,
        viewMode: SyntaxTreeViewMode = .fixedUp
    ) -> T? {
        let instance = SyntaxTree(viewMode: viewMode, declarationSyntax: declarationSyntax)
        instance.collectChildren()
        return instance.declarations(of: type).first
    }

    // MARK: - Internal Convenience Enabler

    internal func declarations<T: Declaration>(of type: T.Type) -> [T] {
        var result: [Any] = []
        switch type {
        case is Class.Type:
            result = classes
        case is ConditionalCompilationBlock.Type:
            result = conditionalCompilationBlocks
        case is Deinitializer.Type:
            result = deinitializers
        case is Enumeration.Type:
            result = enumerations
        case is Extension.Type:
            result = extensions
        case is Function.Type:
            result = functions
        case is Import.Type:
            result = imports
        case is Initializer.Type:
            result = initializers
        case is Operator.Type:
            result = operators
        case is PrecedenceGroup.Type:
            result = precedenceGroups
        case is ProtocolDecl.Type:
            result = protocols
        case is Structure.Type:
            result = structures
        case is Subscript.Type:
            result = subscripts
        case is Typealias.Type:
            result = typealiases
        case is Variable.Type:
            result = variables
        default:
            break
        }
        return (result as? [T]) ?? []
    }
}
