//
//  SyntaxSourceLocationResolving.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public protocol SyntaxSourceLocationResolving {

    /// The location of the declaration source within the parent ``SyntaxSparrow/SyntaxExplorerContext``
    var sourceLocation: SyntaxSourceLocation { get }
}

public extension Declaration where Self: SyntaxSourceLocationResolving {

    /// Will return a range for extracting a substring by using the `utf8Offset`
    /// - Parameter source: The source string to calculate the range within.
    /// - Returns: `Range<String.Index>` or `nil` if the range is invalid within the given string.
    func substringRange(in source: String) -> Range<String.Index>? {
        guard let startOffset = sourceLocation.start.utf8Offset, let endOffset = sourceLocation.end.utf8Offset else { return nil }
        guard startOffset < source.count, endOffset <= source.count else { return nil }
        let startIndex = String.Index(utf16Offset: startOffset, in: source)
        let endIndex = String.Index(utf16Offset: endOffset, in: source)
        return Range<String.Index>(uncheckedBounds: (startIndex, endIndex))
    }

    /// Will utilise the `substringRange(in:)` method to extract the declaration from the given source.
    /// - Parameter source: The source string to extrace from.
    /// - Returns: `String` or `nil` if the bounds are invalid
    func extractFromSource(_ source: String) -> String? {
        guard let range = substringRange(in: source) else { return nil }
        return String(source[range])
    }
}
