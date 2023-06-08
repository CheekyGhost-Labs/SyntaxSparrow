//
//  String+Convenience.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

extension String {
    /// Convenience method to trim whitespaces and newlines from a string.
    var trimmed: String {
        trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
