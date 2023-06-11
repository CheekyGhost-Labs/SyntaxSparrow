//
//  SyntaxSourceDetails.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

/// Struct representing the raw source for a supporting ``SyntaxSparrow/Declaration` conforming instance
public struct SyntaxSourceDetails {
    
    /// The start and end bounds of the source.
    public let location: SyntaxSourceLocation

    /// The extracted source contents based on the `location` property.
    /// Will be an empty string if extraction failed.
    public let source: String

    // MARK: - Lifecycle

    public init(location: SyntaxSourceLocation, source: String?) {
        self.location = location
        self.source = source ?? ""
    }

    // MARK: - Convenience

    /// Will return a range for extracting a substring from the given source contents by using the `utf8Offset`
    /// - Parameter source: The source string to calculate the range within.
    /// - Returns: `Range<String.Index>` or `nil` if the range is invalid within the given string.
    public func substringRange(in source: String) -> Range<String.Index>? {
        location.substringRange(in: source)
    }

    /// Will return a range for extracting a substring by using the `utf8Offset`
    /// - Parameter source: The source string to calculate the range within.
    /// - Returns: `NSRange` or `nil` if the range is invalid within the given string.
    public func stringRange(in source: String) -> NSRange? {
        location.stringRange(in: source)
    }
}
