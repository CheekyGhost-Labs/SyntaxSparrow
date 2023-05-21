//
//  XCTest+Convenience.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import XCTest
import SyntaxSparrow

extension XCTest {

    func XCTAssertSourceStartPositionEquals(
        _ lhs: SyntaxSourceLocation,
        _ rhs: (line: Int, column: Int, utf8Offset: Int),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let makeStr: (Int?) -> String = { value in
            guard let value = value else { return "nil" }
            return String(value)
        }
        XCTAssertEqual(lhs.start.line, rhs.line,
            "line `\(makeStr(lhs.start.line))` does not equal `\(String(rhs.line))`",
            file: file, line: line
        )
        XCTAssertEqual(
            lhs.start.column, rhs.column,
            "column `\(makeStr(lhs.start.column))` does not equal `\(String(rhs.column))`",
            file: file, line: line
        )
        XCTAssertEqual(
            lhs.start.utf8Offset, rhs.utf8Offset,
            "utf8Offset `\(makeStr(lhs.start.utf8Offset))` does not equal `\(String(rhs.utf8Offset))`",
            file: file, line: line
        )
    }

    func XCTAssertSourceEndPositionEquals(
        _ lhs: SyntaxSourceLocation,
        _ rhs: (line: Int, column: Int, utf8Offset: Int),
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let makeStr: (Int?) -> String = { value in
            guard let value = value else { return "nil" }
            return String(value)
        }
        XCTAssertEqual(
            lhs.end.line, rhs.line,
            "line `\(makeStr(lhs.end.line))` does not equal `\(String(rhs.line))`",
            file: file, line: line
        )
        XCTAssertEqual(
            lhs.end.column, rhs.column,
            "column `\(makeStr(lhs.end.column))` does not equal `\(String(rhs.column))`",
            file: file, line: line
        )
        XCTAssertEqual(
            lhs.end.utf8Offset, rhs.utf8Offset,
            "utf8Offset `\(makeStr(lhs.end.utf8Offset))` does not equal `\(String(rhs.utf8Offset))`",
            file: file, line: line
        )
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
