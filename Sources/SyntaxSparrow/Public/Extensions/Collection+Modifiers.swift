//
//  File.swift
//  
//
//  Created by Michael O'Brien on 9/5/2024.
//

import Foundation
import SwiftSyntax

public extension Collection where Element == Modifier {
    
    /// Will return true when the collection contains a ``Modifier`` whose ``Modifier/name`` matches the given keyword.
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
    func containsKeyword(_ keyword: Keyword, withDetail detail: String? = nil) -> Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(keyword) && $0.detail == detail })
    }

    /// Returns `true` when the `public` keyword is within the collection.
    ///
    /// For example:
    /// ```swift
    /// public var name: String = ""
    /// public func executeOrder66() {}
    /// public enum SomeType {}
    /// ```
    var containsPublic: Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(.public) })
    }
    
    /// Returns `true` when the `open` keyword is within the collection.
    ///
    /// For example:
    /// ```swift
    /// open var name: String = ""
    /// open func executeOrder66() {}
    /// open class SomeType {}
    /// ```
    var containsOpen: Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(.open) })
    }

    /// Returns `true` when the `private` keyword is within the collection with no detail assigned.
    ///
    /// For example:
    /// ```swift
    /// private var name: String = ""
    /// private func executeOrder66() {}
    /// private class SomeType {}
    /// ```
    var containsPrivate: Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(.private) && $0.detail == nil })
    }

    /// Returns `true` when the `private` keyword is within the collection with the `set` detail assigned.
    ///
    /// For example:
    /// ```swift
    /// private(set) var name: String = ""
    /// ```
    var containsPrivateSetter: Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(.private) && $0.detail == "set" })
    }

    /// Returns `true` when the `private` keyword is within the collection with no detail assigned.
    ///
    /// For example:
    /// ```swift
    /// final var name: String = ""
    /// final func executeOrder66() {}
    /// final class SomeType {}
    /// ```
    var containsFinal: Bool {
        contains(where: { $0.node.name.tokenKind == .keyword(.final) })
    }
}
