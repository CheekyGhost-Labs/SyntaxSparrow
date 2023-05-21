//
//  Parameter.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Struct representing a parameter found within an `Initializer`,`Function`, `Subscript`, etc
/// A parameter has common properties, and then a ``SyntaxSparrow/Parameter/Type`` property which further describes the input by including associated properties
/// as needed.
/// For example, a parameter with the type`.closure` will have a `Closure` provided, where as a parameter with the `.tuple` type will have a `Tuple` associated properties.
public struct Parameter: Hashable, Equatable, CustomStringConvertible {

    // MARK: - Properties

    /// Array of attributes found in the declaration.
    ///
    /// - See: ``SyntaxSparrow/Attribute``
    var attributes: [Attribute] { resolver.attributes }

    /// The first, external name of the parameter.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func increment(_ number: Int, by amount: Int)
    /// ```
    /// - The first parameter has a `name` equal to `"_"`
    /// - The second parameter has a `name` equal to `"by"`
    var name: String? { resolver.name }

    /// The second internal name of the parameter.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func increment(_ number: Int, by amount: Int)
    /// ```
    /// - The first parameter has a `secondName` equal to `"number"`
    /// - The second parameter has a `secondName` equal to `"amount"`
    var secondName: String? { resolver.secondName }

    /// The `EntityType` resolve from the parameter
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func greet(_ person: Person, with phrases: String, dimensions: (height: Double, weight: Double))
    /// ```
    /// - The first parameter type will be `.simple("Person")`
    /// - The second parameter type will be `.simple("String")`
    /// - The third parameter type will be `.dimensions(Tuple)` where the associated tuple has parameters with types `.simple("Double")` and `.simple("Double")`
    /// - See: ``SyntaxSparrow/EntityType``
    var type: EntityType { resolver.type }

    /// The raw type string.
    var rawType: String? { resolver.rawType }

    /// Bool whether the parameter accepts a variadic argument.
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func greet(_ person: Person, with phrases: String...)
    /// ```
    /// - The second parameter is variadic
    var isVariadic: Bool { resolver.isVariadic }

    /// Will return a `Bool` flag indicating if the closure declaration is marked as optional. `?`
    var isOptional: Bool { resolver.isOptional }

    /// The default argument of the parameter (if any).
    ///
    /// For example, given the following declaration:
    /// ```swift
    /// func processCount(_ number: Int, by amount: Int = 1)
    /// ```
    /// - The second parameter has a default argument equal to `"1"`.
    var defaultArgument: String? { resolver.defaultArgument }

    /// Bool whether the parameter is marked with `inout`
    ///
    /// For example, in the following declaration:
    /// ```swift
    /// func processForm(_ form: inout Form)
    /// ```
    /// - The parameter is inout
    var isInOut: Bool { resolver.isInOut }

    /// Bool whether the parameter name is marked as no label `_`.
    ///
    ///For example, in the following declaration:
    /// ```swift
    /// func processResult(_ result: Result<String, Error>)
    /// ```
    /// - The parameter has the label ommitted.
    ///
    /// **Note:** This will be `false` for completely label-less types. For example:
    /// ```swift
    /// typealias Person = (String, Int)
    /// ```
    /// - Both parameter arguments in the tuple will have `isLabelOmitted` as `false`
    var isLabelOmitted: Bool { name == "_" }

    // MARK: - Properties: Resolving

    var resolver: any ParameterNodeSemanticsResolving

    // MARK: - Lifecycle

    public init(node: FunctionParameterSyntax) {
        self.resolver = FunctionParameterSemanticsResolver(node: node)
    }

    public init(node: TupleTypeElementSyntax) {
        self.resolver = TupleParameterSemanticsResolver(node: node)
    }

    // MARK: - Equatable

    public static func == (lhs: Parameter, rhs: Parameter) -> Bool {
        return lhs.description == rhs.description
    }

    // MARK: - Hashable

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(description.hashValue)
    }

    // MARK: - CustomStringConvertible

    public var description: String {
        resolver.node.description.trimmed
    }
}
