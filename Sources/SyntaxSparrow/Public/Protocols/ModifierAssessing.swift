//
//  ModifierAssessing.swift
//
//
//  Created by Michael O'Brien on 9/5/2024.
//

import Foundation
import SwiftSyntax

/// ``ModifierAssessing`` conforming instances provide convenience assessments of an expected array of ``Modifier`` instances.
public protocol ModifierAssessing {

    /// Array of modifiers found in the declaration.
    /// - See: ``SyntaxSparrow/Modifier``
    var modifiers: [Modifier] { get }

    /// Returns `true` when the `public` keyword is within the collection.
    ///
    /// For example:
    /// ```swift
    /// public var name: String = ""
    /// public func executeOrder66() {}
    /// public enum SomeType {}
    /// ```
    var isPublic: Bool { get }

    /// Returns `true` when the `public`, `open`, `private`, and `fileprivate` keywords are not contained in the collection.
    ///
    /// **Note: ** Will also assess whether the internal keyword is explicitly present.
    ///
    /// For example:
    /// ```swift
    /// var name: String = ""
    /// func executeOrder66() {}
    /// enum SomeType {}
    /// ```
    var isInternal: Bool { get }

    /// Returns `true` when the `open` keyword is within the collection.
    ///
    /// For example:
    /// ```swift
    /// open var name: String = ""
    /// open func executeOrder66() {}
    /// open class SomeType {}
    /// ```
    var isOpen: Bool { get }

    /// Returns `true` when the `private` keyword is within the collection with no detail assigned.
    ///
    /// For example:
    /// ```swift
    /// private var name: String = ""
    /// private func executeOrder66() {}
    /// private class SomeType {}
    /// ```
    var isPrivate: Bool { get }

    /// Returns `true` when the `filePrivate` keyword is within the collection with no detail assigned.
    ///
    /// For example:
    /// ```swift
    /// fileprivate var name: String = ""
    /// fileprivate func executeOrder66() {}
    /// fileprivate class SomeType {}
    /// ```
    var isFilePrivate: Bool { get }

    /// Returns `true` when the `private` keyword is within the collection with no detail assigned.
    ///
    /// For example:
    /// ```swift
    /// final var name: String = ""
    /// final func executeOrder66() {}
    /// final class SomeType {}
    /// ```
    var isFinal: Bool { get }

    /// Will return true when the ``ModifierAssessing/modifiers`` collection contains a modifier whose ``Modifier/name`` matches the given keyword.
    ///
    /// You can also provide a detail to assess. For example
    /// ```swift
    /// private(set) public var name: String = "foo"
    /// ```
    /// the following would return `true`:
    /// ```swift
    /// collection.containsKeyword(.private, withDetail: "set")
    /// ```
    /// - Parameters:
    ///   - keyword: The keyword to search for
    ///   - detail: Optional detail assigned to the modifier.
    /// - Returns: Bool
    func containsModifierWithKeyword(_ keyword: Keyword, withDetail detail: String?) -> Bool
}

extension ModifierAssessing {

    public var isPublic: Bool { containsModifierWithKeyword(.public) }

    public var isOpen: Bool { containsModifierWithKeyword(.open) }

    public var isPrivate: Bool { containsModifierWithKeyword(.private) }

    public var isFilePrivate: Bool { containsModifierWithKeyword(.fileprivate) }

    public var isFinal: Bool { containsModifierWithKeyword(.final) }

    public var isInternal: Bool {
        (!isPublic && !isOpen && !isPrivate && !isFilePrivate) || containsModifierWithKeyword(.internal)
    }

    public func containsModifierWithKeyword(_ keyword: Keyword, withDetail detail: String? = nil) -> Bool {
        modifiers.lazy.containsKeyword(keyword, withDetail: detail)
    }
}

// MARK: - Conformance

extension Actor: ModifierAssessing {}
extension Class: ModifierAssessing {}
extension Enumeration: ModifierAssessing {}
extension Extension: ModifierAssessing {}
extension Function: ModifierAssessing {}
extension ProtocolDecl: ModifierAssessing {}
extension Structure: ModifierAssessing {}
extension Subscript: ModifierAssessing {}
extension Typealias: ModifierAssessing {}

extension Variable: ModifierAssessing {

    /// Returns `true` when the `private` keyword is within the modifier collection with the `set` detail assigned.
    ///
    /// For example:
    /// ```swift
    /// private(set) var name: String = ""
    /// ```
    public var isPrivateSetter: Bool { containsModifierWithKeyword(.private, withDetail: "set") }

    /// Returns `true` when the `fileprivate` keyword is within the modifier collection with the `set` detail assigned.
    ///
    /// For example:
    /// ```swift
    /// private(set) var name: String = ""
    /// ```
    public var isFilePrivateSetter: Bool { containsModifierWithKeyword(.fileprivate, withDetail: "set") }
}

extension Initializer: ModifierAssessing {

    /// Returns `true` when the `required` keyword is within the modifier collection.
    ///
    /// For example:
    /// ```swift
    /// required init(name: String) {}
    /// ```
    public var isRequired: Bool { containsModifierWithKeyword(.required) }

    /// Returns `true` when the `convenience` keyword is within the modifier collection.
    ///
    /// For example:
    /// ```swift
    /// convenience init(name: String) {}
    /// ```
    public var isConvenience: Bool { containsModifierWithKeyword(.convenience) }
}
