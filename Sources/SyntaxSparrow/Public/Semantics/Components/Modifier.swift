//
//  Modifier.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Struct representing a modifier on a declaration.
///
/// Declarations may have one or more modifiers for various purposes:
/// - Specifying access control (`private`, `public`, etc)
/// - Declaring type membership (`class`, `static`, etc)
/// - Designating mutability (`nonmutating`)
/// A declaration modifier may also specify additional details within enclosing parentheses `()` following it's name.
///
/// For example, the following declaration has two modifiers:
/// ```swift
/// private(set) public var title: String
/// ```
/// - The first modifier has a `name` equal to `"public"` and `nil` for `detail`
/// - The second modifier has a `name` equal to `"private"` and a `detail` equal to `"set"`
public struct Modifier: DeclarationComponent {

    // MARK: - Properties: DeclarationComponent

    public let node: DeclModifierSyntax

    // MARK: - Properties

    /// The declaration modifier name.
    public var name: String {
        node.name.text.trimmed
    }

    /// The modifier detail, if any.
    public var detail: String? {
        node.detail?.detail.text.trimmed
    }

    // MARK: - Lifecycle

    /// Creates a new ``SyntaxSparrow/Modifier`` instance from an `DeclModifierSyntax` node.
    public init(node: DeclModifierSyntax) {
        self.node = node
    }
}
