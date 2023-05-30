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

        public static let empty: Position = Position(line: nil, offset: nil, utf8Offset: nil)

        public init(line: Int?, offset: Int?, utf8Offset: Int?) {
            self.line = line
            self.column = offset
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

    // MARK: - Internal

    public static let empty: SyntaxSourceLocation = SyntaxSourceLocation(start: .empty, end: .empty)
}
