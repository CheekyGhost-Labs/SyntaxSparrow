//
//  SyntaxSourceLocation.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public struct SyntaxSourceLocation: Equatable, Codable, Hashable {
    public struct Position: Equatable, Codable, Hashable {
        /// The line number the declaration was made on.
        ///
        /// Will be `nil` if unresolvable.
        public let line: Int?

        /// The horizontal offset (column) the declaration begins at on the `line`.
        ///
        /// Will be `nil` if unresolvable.
        public let column: Int?

        /// The UTF-8 byte offset into the file where this location resides.
        ///
        /// Will be `nil` if unresolvable.
        public let utf8Offset: Int?

        // MARK: - Lifecycle

        public static let empty: Position = .init(line: nil, offset: nil, utf8Offset: nil)

        public init(line: Int?, offset: Int?, utf8Offset: Int?) {
            self.line = line
            column = offset
            self.utf8Offset = utf8Offset
        }
    }

    // MARK: - Properties

    /// The line and column position the declaration starts at.
    /// - See: ``SyntaxSparrow/SyntaxSourceLocation/Position``
    public let start: Position

    /// The line and column position the declaration ends at.
    /// - See: ``SyntaxSparrow/SyntaxSourceLocation/Position``
    public let end: Position
    
    /// Returns a location with empty start/end properties.
    public static let empty: SyntaxSourceLocation = .init(start: .empty, end: .empty)

    // MARK: - Internal

    /// Will return a range for extracting a substring by using the `utf8Offset`
    /// - Parameter source: The source string to calculate the range within.
    /// - Returns: `Range<String.Index>` or `nil` if the range is invalid within the given string.
    func substringRange(in source: String) -> Range<String.Index>? {
        guard let startOffset = start.utf8Offset, let endOffset = end.utf8Offset else { return nil }
        guard startOffset < source.count, endOffset <= source.count else { return nil }
        let startIndex = String.Index(utf16Offset: startOffset, in: source)
        let endIndex = String.Index(utf16Offset: endOffset, in: source)
        return Range<String.Index>(uncheckedBounds: (startIndex, endIndex))
    }

    /// Will return a range for extracting a substring by using the `utf8Offset`
    /// - Parameter source: The source string to calculate the range within.
    /// - Returns: `NSRange` or `nil` if the range is invalid within the given string.
    func stringRange(in source: String) -> NSRange? {
        guard let subRange = substringRange(in: source) else { return nil }
        return NSRange(subRange, in: source)
    }

    /// Will utilise the `substringRange(in:)` method to extract the declaration from the given source.
    /// - Parameter source: The source string to extrace from.
    /// - Returns: `String` or `nil` if the bounds are invalid
    func extractFromSource(_ source: String) -> String? {
        guard let range = substringRange(in: source) else { return nil }
        return String(source[range])
    }
}
