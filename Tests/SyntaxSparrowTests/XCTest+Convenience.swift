//
//  XCTest+Convenience.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SyntaxSparrow
import XCTest

extension XCTest {

    // MARK: - Attributes

    func XCTAssertAttributesArgumentsEqual(
        _ lhs: Attribute,
        _ rhs: [(name: String?, value: String)],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        XCTAssertEqual(lhs.arguments.count, rhs.count, "Arguments count `\(lhs.arguments.count)` does not equal `\(rhs.count)`")
        for (index, argument) in lhs.arguments.enumerated() {
            XCTAssertEqual(
                argument.name, rhs[index].name,
                "argument[`\(index)`].name `\(argument.name ?? "nil")` does not equal `\(rhs[index].name ?? "nil")`",
                file: file, line: line
            )
            XCTAssertEqual(
                argument.value, rhs[index].value,
                "argument[`\(index)`].value `\(argument.value)` does not equal `\(rhs[index].value)`",
                file: file, line: line
            )
        }
    }

    // MARK: - Source Details

    func AssertSourceDetailsEquals(
        _ details: SyntaxSourceDetails,
        start: (line: Int, column: Int, utf8Offset: Int),
        end: (line: Int, column: Int, utf8Offset: Int),
        source: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        // Start
        let incomingStart = (details.location.start.line, details.location.start.column, details.location.start.utf8Offset)
        if incomingStart.0 != start.line || incomingStart.1 != start.column || incomingStart.2 != start.utf8Offset {
            XCTFail(buildPositionFailureMessage("start: ", incomingStart, start), file: file, line: line)
        }
        // End
        let incomingEnd = (details.location.end.line, details.location.end.column, details.location.end.utf8Offset)
        if incomingEnd.0 != end.line || incomingEnd.1 != end.column || incomingEnd.2 != end.utf8Offset {
            XCTFail(buildPositionFailureMessage("end: ", incomingEnd, end), file: file, line: line)
        }
        // Source
        XCTAssertEqual(details.source, source, file: file, line: line)
    }

    // MARK: - Helpers

    func getSourceLocation(for declaration: any Declaration, from instance: SyntaxTree) -> SyntaxSourceDetails {
        guard let details = try? instance.extractSource(forDeclaration: declaration) else {
            return SyntaxSourceDetails(location: .empty, source: nil)
        }
        return details
    }

    private func buildPositionFailureMessage(
        _ prefix: String = "",
        _ lhs: (line: Int?, column: Int?, utf8Offset: Int?),
        _ rhs: (line: Int, column: Int, utf8Offset: Int)
    ) -> String {
        let makeStr: (Int?) -> String = { value in
            guard let value = value else { return "nil" }
            return String(value)
        }
        let expected = "(\(makeStr(lhs.line)), \(makeStr(lhs.column)), \(makeStr(lhs.utf8Offset)))"
        let incoming = "(\(rhs.line), \(rhs.column), \(rhs.utf8Offset))"
        return "\(prefix)`\(expected)` is not equal to expected: \(incoming)"
    }
}
