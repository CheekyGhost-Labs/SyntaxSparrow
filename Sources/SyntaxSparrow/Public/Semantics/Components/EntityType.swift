//
//  EntityType.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// An ``EntityType`` represents a type being referenced by a property or parameter. It is encapsulated in the ``EntityType``
/// enumeration to provide a more simple entry point when working with sets of parameter inputs and properties.
/// By default a ``SyntaxSparrow/EntityType/simple(_:)`` type will be used with a string representation of the declared type.
/// Initial support for some complex types, such as closures, tuples, and results is provided.
/// As support for more complex types are added they will be added as a dedicated enumeration case to the `EntityType`
public enum EntityType: Equatable, Hashable, CustomStringConvertible {
    /// A `simple` type refers to a standard swift type can't does not have any nested or related syntax.
    /// **Note:** This is also used for any unsupported syntax types. i.e `CVarArg` is not currently supported so it will use the
    /// `.simple("CVarArg...")`
    case simple(_ type: String)

    /// A `array` type is used when a parameter's type is a valid ``SyntaxSparrow/ArrayDecl`` type.
    ///
    /// The `Array` supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func example(names: [String])
    /// func example(names: Array<String>)
    /// ```
    /// would have a type of `.array(Array)` where the ``SyntaxSparrow/ArrayDecl`` has the `elementType` of `.simple("String")`.
    case array(_ array: ArrayDecl)

    /// A `array` type is used when a parameter's type is a valid ``SyntaxSparrow/SetDecl`` type.
    ///
    /// The `Set` supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func example(names: Set<String>)
    /// ```
    /// would have a type of `.set(Set)` where the ``SyntaxSparrow/SetDecl`` has the `elementType` of `.simple("String")`.
    case set(_ set: SetDecl)

    /// A `array` type is used when a parameter's type is a valid ``SyntaxSparrow/DictionaryDecl`` type.
    ///
    /// The `Set` supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func example(names: [String: Int])
    /// func example(names: Dictionary<String, Int>)
    /// ```
    /// would have a type of `.dictionary(DictionaryDecl)` where the ``SyntaxSparrow/DictionaryDecl`` has
    /// the `keyType` of `.simple("String")` and the `.elementType` of `.simple("Int")`.
    case dictionary(_ dictionary: DictionaryDecl)

    /// A `tuple` type is used when a parameter's type is a valid ``SyntaxSparrow/Tuple`` type.
    ///
    /// The `Tuple` type supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func example(withPerson person: (name: String, age: Int)) { ... }
    /// ```
    /// would have a type of `.tuple(Tuple)` where the ``SyntaxSparrow/Tuple`` has `Parameter`arguments with types `.simple("String"), .simple("Int")`
    case tuple(_ tuple: Tuple)

    /// A `closure` type is used when a parameter's type resolves to a valid `Closure`.
    ///
    /// The `Closure` type supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func example(_ handler: (name: String, age: Int) -> Void) { ... }
    /// ```
    /// would have a type of `.closure(Closure)` where the `Closure` has input arguments with types `.simple("String"), .simple("Int")`
    case closure(_ closure: Closure)

    /// A `result` type is used when a parameter's type resolves to a valid `Result`.
    ///
    /// The `Result` type supports `isOptional` to derive if the type has the optional/`?` suffix.
    ///
    /// For example,
    /// ```swift
    /// func processResult(_ result: Result<String, Error>) { ... }
    /// ```
    /// would have a type of `.result(Result)` where the `Result` type represents a computation that can either result in a value of type `String`
    /// (the success case) or an `Error` (the failure case).
    case result(_ result: Result)

    /// A `void` type is used when a parameter's type resolves to `Void`. It includes the raw declaration (`"Void"` or `"()"`) includes if the type is optional.
    ///
    /// For example,
    /// ```swift
    /// func example(_ handler: ()) { ... }
    /// func example(_ handler: Void) { ... }
    /// func example(_ handler: () -> Void) { ... }
    /// ```
    /// - The first function would have a parameter with the type `.void`
    /// - The second function would have a parameter with the type `.void`
    /// - The third function would have a parameter with the type `.closure(Closure)` where the closure input and output are both `.void`
    case void(_ raw: String, _ isOptional: Bool)

    /// An `empty` type refers to a when a parameter or property is partially declared and does not have a type defined.
    ///
    /// **Note:** This is not best practice, but as the parser can iterate over these declarations, it avoids having an optional type to work with.
    case empty

    // MARK: - Conformance: CustomStringConvertible

    public var description: String {
        switch self {
        case let .simple(type):
            return type
        case let .array(array):
            return array.description
        case let .set(set):
            return set.description
        case let .dictionary(dictionary):
            return dictionary.description
        case let .tuple(tuple):
            return tuple.description
        case let .closure(closure):
            return closure.description
        case let .result(result):
            return result.description
        case let .void(rawType, isOptional):
            if rawType.hasSuffix("?") { return rawType }
            return "\(rawType)\(isOptional ? "?" : "")"
        case .empty:
            return ""
        }
    }

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/EntityType`` instance from a `TypeSyntax` node.
    public init(_ typeSyntax: TypeSyntax) {
        self = EntityType.parseType(typeSyntax)
    }

    /// Creates a new ``SyntaxSparrow/EntityType`` instance from a `GenericArgumentSyntax.Argument` node.
    public init(_ argument: GenericArgumentSyntax.Argument) {
        switch argument {
        case .type(let typeSyntax):
            self = EntityType.parseType(typeSyntax)
        default:
            self = .empty
        }
    }
}
