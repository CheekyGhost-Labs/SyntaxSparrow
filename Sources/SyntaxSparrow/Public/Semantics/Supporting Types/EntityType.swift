//
//  EntityType.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

/// An ``EntityType`` represents a type being referenced by a property or parameter. It is encapsulated in the ``EntityType``
/// enumeration to provide a more simple entry point when working with sets of parameter inputs and properties.
/// By default a ``SyntaxSparrow/EntityType/simple(_:)`` type will be used with a string representation of the declared type.
/// Initial support for some complex types, such as closures, tuples, and results is provided.
/// As support for more complex types are added they will be added as a dedicated enumeration case to the `EntityType`
public enum EntityType: Equatable, Hashable, CustomStringConvertible {
    /// A `simple` type refers to a standard swift type can't does not have any nested or related syntax. Also provides if the type is optional.
    /// `.simple("String?", true)`
    /// `.simple("String", false)`
    /// **Note:** This is also used for any unsupported syntax types. i.e `CVarArg` is not currently supported so it will use the
    /// `.simple("CVarArg...", false)`
    case simple(_ type: String, _ isOptional: Bool)

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

    /// A `void` type is used when a parameter's type resolves to `Void`. Also includes if the type is optional.
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
    case void(_ isOptional: Bool)

    /// An `empty` type refers to a when a parameter or property is partially declared and does not have a type defined.
    ///
    /// **Note:** This is not best practice, but as the parser can iterate over these declarations, it avoids having an optional type to work with.
    case empty

    // MARK: - Conformance: CustomStringConvertible

    public var description: String {
        switch self {
        case let .simple(type, _):
            return type.description
        case let .tuple(tuple):
            return tuple.description
        case let .closure(closure):
            return closure.description
        case let .result(result):
            return result.description
        case .void(let isOpional):
            return "Void\(isOpional ? "?" : "")"
        case .empty:
            return ""
        }
    }
}
