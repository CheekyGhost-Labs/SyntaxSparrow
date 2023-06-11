//
//  SyntaxTreeError.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation

public enum SyntaxTreeError: LocalizedError {
    case unableToResolveFileAtPath(String)
    case invalidContextForSourceResolving(String)
}
