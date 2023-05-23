//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public struct Result: Hashable, Equatable, CustomStringConvertible {

    var successType: EntityType { .simple("") }

    let errorType: String = ""

    public func hash(into hasher: inout Hasher) {

    }

    public var description: String {
        ""
    }
}
