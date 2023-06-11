//
//  SyntaxExplorerContext.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public protocol SyntaxExplorerContextProviding {
    /// The source code being analyzed by this instance.
    ///
    /// This property holds the current source code being analyzed. The source code should be a valid Swift source code string. If you need
    /// to update the source code being analyzed, use the `updateToSource(_:)` method instead of
    /// directly changing the value of this property.
    var sourceBuffer: String? { get }

    /// The mode in which the syntax tree is traversed. This influences how the `SyntaxExplorer` handles unexpected or invalid tokens.
    ///
    /// The `SyntaxTreeViewMode` is crucial in shaping the behavior of the `SyntaxExplorer` during syntax tree traversal. It is critical to choose
    /// the appropriate view mode considering the state of the source code being analyzed.
    ///
    /// - `strict`: In this mode, the explorer expects well-formed and valid Swift syntax. If it encounters unexpected or invalid tokens,
    /// it throws an error and halts the traversal. This mode should be used when the source code is known to be error-free, such as after successful
    /// compilation.
    /// - `tolerant`: In this mode, the explorer is more lenient and tries to recover from unexpected or invalid tokens, continuing the
    /// traversal as best as it can. This mode should be used when the source code might contain errors, such as during editing or in the case of
    /// partial code snippets.
    /// - `fixedUp`: This mode aims to strike a balance between `strict` and `tolerant`. It attempts to fix up minor errors in the source code while
    /// parsing, allowing
    /// for smoother traversal. However, for major errors, it behaves like the `strict` mode and throws an error. This mode can be useful when working
    /// with code that may
    /// contain minor errors, but is largely well-formed.
    ///
    /// The `viewMode` property of the `SyntaxExplorer` holds the chosen `SyntaxTreeViewMode` value for the instance and its child nodes.
    var viewMode: SyntaxTreeViewMode { get }

    /// The `SourceLocationConverter` instance used for resolving the start and end bounds of declarations.
    ///
    /// **Note:** This property is configured for use when the ``SyntaxSparrow/SyntaxTree/collectChildren()`` method is invoked. If an empty or
    /// invalid
    /// locator is detected, it will be re-created when needed based on the current parsing context.
    var sourceLocationConverter: SparrowSourceLocationConverter { get }

    /// Bool flag indicating if the latest `sourceBuffer` has not been collected yet.
    ///
    /// If this flag is `true` you should run the ``SyntaxSparrow/SyntaxTree/collectChildren()`` or equivilant collection method to ensure the
    /// collected
    /// declarations are up to date.
    var isStale: Bool { get }
}

/// Struct holding contextual instances and details created on a ``SyntaxSparrow/SyntaxTree`` instance.
/// These support structured concurrency as elements such as the ``SyntaxSparrow/SparrowSourceLocationConverter`` are
/// alo used by child evaluations and collectors at different times.
public struct SyntaxExplorerContext: SyntaxExplorerContextProviding {
    // MARK: - Properties: SyntaxExplorerContextProviding

    public private(set) var sourceBuffer: String?

    public private(set) var viewMode: SyntaxTreeViewMode

    public private(set) var sourceLocationConverter: SparrowSourceLocationConverter

    public private(set) var isStale: Bool = true

    // MARK: - Lifecycle

    public init(
        viewMode: SyntaxTreeViewMode,
        sourceBuffer: String?,
        sourceLocationConverter: SparrowSourceLocationConverter? = nil,
        isStale: Bool = true
    ) {
        self.viewMode = viewMode
        self.sourceBuffer = sourceBuffer
        self.sourceLocationConverter = sourceLocationConverter ?? .empty
        self.isStale = isStale
    }

    // MARK: - Helpers: Internal

    /// Will update the `sourceBuffer` property to the given string. If it does not match the current buffer the `isStale` will be set to `true`.
    /// - Parameter source: The source to update to.
    mutating func updateSourceBuffer(to source: String) {
        isStale = (sourceBuffer != source)
        sourceBuffer = source
    }

    /// Will reset the `isStale` status to `false`.
    mutating func resetIsStale() {
        isStale = false
    }

    // MARK: - Helpers: Collectors

    func createRootDeclarationCollector() -> RootDeclarationCollector {
        RootDeclarationCollector(viewMode: viewMode)
    }

    func protocolAssociatedTypeCollector() -> ProtocolAssociatedTypeCollector {
        ProtocolAssociatedTypeCollector(viewMode: viewMode)
    }
}
