//
//  XCTest+Convenience.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SyntaxSparrow
import XCTest

extension XCTest {

    private func buildPositionFailureMessage(
        _ lhs: (line: Int?, column: Int?, utf8Offset: Int?),
        _ rhs: (line: Int, column: Int, utf8Offset: Int)
    ) -> String {
        let makeStr: (Int?) -> String = { value in
            guard let value = value else { return "nil" }
            return String(value)
        }
        let expected = "(\(makeStr(lhs.line)), \(makeStr(lhs.column)), \(makeStr(lhs.utf8Offset)))"
        let incoming = "(\(rhs.line), \(rhs.column), \(rhs.utf8Offset))"
        return "`\(expected)` is not equal to expected: \(incoming)"
    }

    func XCTAssertSourceStartPositionEquals(
        _ lhs: SyntaxSourceLocation,
        _ rhs: (line: Int, column: Int, utf8Offset: Int),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let incoming = (lhs.start.line, lhs.start.column, lhs.start.utf8Offset)
        guard incoming.0 == rhs.line, incoming.1 == rhs.column, incoming.2 == rhs.utf8Offset else {
            XCTFail(buildPositionFailureMessage(incoming, rhs), file: file, line: line)
            return
        }
    }

    func XCTAssertSourceEndPositionEquals(
        _ lhs: SyntaxSourceLocation,
        _ rhs: (line: Int, column: Int, utf8Offset: Int),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let incoming = (lhs.end.line, lhs.end.column, lhs.end.utf8Offset)
        guard incoming.0 == rhs.line, incoming.1 == rhs.column, incoming.2 == rhs.utf8Offset else {
            XCTFail(buildPositionFailureMessage(incoming, rhs), file: file, line: line)
            return
        }
    }

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
}
