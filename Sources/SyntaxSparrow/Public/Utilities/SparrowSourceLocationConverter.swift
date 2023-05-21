//
//  File.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

public class SparrowSourceLocationConverter {

    // MARK: - Properties

    var converter: SourceLocationConverter

    let queue: DispatchQueue = DispatchQueue(label: "com.cheekyghost.SyntaxSparrow.SourceLocationConverter", qos: .userInitiated)

    public var isEmpty: Bool {
        queue.sync {
            converter.sourceLines == [""] || converter.sourceLines.isEmpty
        }
    }

    // MARK: - Lifecycle

    static var empty: SparrowSourceLocationConverter {
        SparrowSourceLocationConverter(file: "", source: "")
    }

    public init(file: String, tree: SyntaxProtocol) {
        self.converter = SourceLocationConverter(file: file, tree: tree)
    }

    public init(file: String, source: String) {
        self.converter = SourceLocationConverter(file: file, source: source)
    }

    public init(rootParentOf node: SyntaxProtocol, file: String = "") {
        self.converter = SourceLocationConverter(file: file, tree: node.root)
    }

    // MARK: - Helpers

    public func updateForTree(_ tree: SyntaxProtocol, file: String = "") {
        converter = SourceLocationConverter(file: file, tree: tree)
    }

    public func udpateForSource(_ source: String, file: String = "") {
        converter = SourceLocationConverter(file: file, source: source)
    }

    public func updateToRootForNode(_ node: SyntaxProtocol, file: String = "") {
        converter = SourceLocationConverter(file: file, tree: node.root)
    }

    public func locationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation {
        queue.sync {
            SyntaxSourceLocation(start: startLocationForNode(node), end: endLocationForNode(node))
        }
    }

    public func startLocationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation.Position {
        guard let token = node.firstToken else { return .empty }
        return queue.sync {
            let location = token.startLocation(converter: converter)
            return normalisedLocation(location)
        }
    }

    public func endLocationForNode(_ node: SyntaxProtocol) -> SyntaxSourceLocation.Position {
        guard let token = node.lastToken else { return .empty }
        return queue.sync {
            let location = token.endLocation(converter: converter)
            return normalisedLocation(location)
        }
    }

    // MARK: - Helpers: Private

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
