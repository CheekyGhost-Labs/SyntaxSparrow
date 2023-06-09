//
//  SyntaxExploringDeclaration.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

protocol DeclarationCollecting {
    /// `DeclarationCollection` instance for collecting any children.
    var declarationCollection: DeclarationCollection { get }

    /// When capable, will collect any immediate child declarations, such as `Structure`, `Class`, `Enumeration`, `Function`, etc from the node being explored.
    ///
    /// Collection will be limited to immediate child declarations since the collected declaration types also support collecting child elements.
    /// **Note:** A valid `SparrowSourceLocationConverter` instance is required for accurate location resolving, this is taken from the `context` on the instance.
    /// - See:``SyntaxSparrow/DeclarationSemanticsResolving/context``
    func collectChildren()
}
