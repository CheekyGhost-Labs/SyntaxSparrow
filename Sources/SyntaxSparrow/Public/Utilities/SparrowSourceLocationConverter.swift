//
//  SparrowSourceLocationConverter.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public class SparrowSourceLocationConverter {
    // MARK: - Properties

    var converter: SourceLocationConverter

    let queue: DispatchQueue = .init(label: "com.cheekyghost.SyntaxSparrow.SourceLocationConverter", qos: .userInitiated)

    public var isEmpty: Bool {
        queue.sync {
            converter.sourceLines == [""] || converter.sourceLines.isEmpty
        }
    }

    // MARK: - Lifecycle

    static var empty: SparrowSourceLocationConverter {
        let syntax = SourceFileSyntax(statements: .init([]))
        return SparrowSourceLocationConverter(file: "", tree: syntax)
    }

    public init(file: String, tree: SyntaxProtocol) {
        converter = SourceLocationConverter(fileName: file, tree: tree)
    }

    @available(
        *,
        deprecated,
        message: "`init(file:source:)' is deprecated: Use `init(fileName:tree:)` instead"
    )
    public init(file: String, source: String) {
        converter = SourceLocationConverter(file: file, source: source)
    }

    public init(rootParentOf node: SyntaxProtocol, file: String = "") {
        converter = SourceLocationConverter(fileName: file, tree: node.root)
    }

    // MARK: - Helpers

    public func updateForTree(_ tree: SyntaxProtocol, file: String = "") {
        queue.async(flags: .barrier) { [self] in
            converter = SourceLocationConverter(fileName: file, tree: tree)
        }
    }

    @available(
        *,
        deprecated,
        message: "`updateForSource(_:file:)' is deprecated: Use `updateForTree(_:file:)` instead"
    )
    public func updateForSource(_ source: String, file: String = "") {
        queue.async(flags: .barrier) { [self] in
            converter = SourceLocationConverter(file: file, source: source)
        }
    }

    public func updateToRootForNode(_ node: SyntaxProtocol, file: String = "") {
        queue.async(flags: .barrier) { [self] in
            converter = SourceLocationConverter(fileName: file, tree: node.root)
        }
    }

    public func locationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation {
        if isEmpty { updateToRootForNode(node) }
        return queue.sync {
            var targetNode: SyntaxProtocol = node
            if node.as(PatternBindingSyntax.self) != nil {
                targetNode = node.context ?? node
            }
            let start = startLocationForNode(targetNode)
            let end = endLocationForNode(targetNode)
            return SyntaxSourceLocation(start: start, end: end)
        }
    }

    // MARK: - Helpers: Private

    private func startLocationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation.Position {
        guard let token = node.firstToken(viewMode: .fixedUp) else { return .empty }
        let location = token.startLocation(converter: converter)
        return normalisedLocation(location)
    }

    private func endLocationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation.Position {
        guard let token = node.lastToken(viewMode: .fixedUp) else { return .empty }
        let location = token.endLocation(converter: converter)
        return normalisedLocation(location)
    }

    private func normalisedLocation(_ location: SourceLocation) -> SyntaxSourceLocation.Position {
        SyntaxSourceLocation.Position(
            line: normalisedPosition(location.line),
            offset: normalisedPosition(location.column),
            utf8Offset: location.offset
        )
    }

    private func normalisedPosition(_ value: Int?) -> Int? {
        guard let value = value else { return nil }
        return max(0, value - 1)
    }
}
