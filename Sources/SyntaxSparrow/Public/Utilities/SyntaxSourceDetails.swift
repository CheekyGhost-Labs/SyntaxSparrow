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
}
