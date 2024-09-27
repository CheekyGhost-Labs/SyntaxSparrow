//
//  Collection+Parameters.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation

public extension Collection where Element == Parameter {

    /// Will return the parameters as they would appear within signature input parenthesis.
    ///
    /// Note: Sending true to the `includeParenthesis` flag (default) will wrap the result in parenthesis.
    /// i.e:
    /// - `true`: `"(_ name: String, age: Int = 0, withOtherThing otherThing: String? = nil)"`
    /// - `false`:`"_ name: String, age: Int = 0, withOtherThing otherThing: String? = nil"`
    ///
    /// - Parameter includeParenthesis: Bool whether to wrap the result in parenthesis. Defaults to `true`.
    /// - Returns: `String`
    func signatureInputString(includeParenthesis: Bool = true) -> String {
        let joined = map(\.description).joined(separator: ", ")
        if includeParenthesis {
            return "(\(joined))"
        }
        return joined
    }
}
