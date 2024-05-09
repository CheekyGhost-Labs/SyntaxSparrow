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
}
