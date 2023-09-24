//
//  OperatorTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class OperatorTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests

    func test_operator_standard_willReoslveExpectedValues() {
        let source = #"""
        prefix operator +++
        postfix operator +++
        infix operator +++
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.operators.count, 3)

        // prefix
        let prefix = instanceUnderTest.operators[0]
        XCTAssertEqual(prefix.name, "+++")
        XCTAssertEqual(prefix.kind, .prefix)
        XCTAssertEqual(prefix.description, "prefix operator +++")
        AssertSourceDetailsEquals(
            getSourceLocation(for: prefix, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 19, 19),
            source: "prefix operator +++"
        )

        // postfix
        let postfix = instanceUnderTest.operators[1]
        XCTAssertEqual(postfix.name, "+++")
        XCTAssertEqual(postfix.kind, .postfix)
        XCTAssertEqual(postfix.description, "postfix operator +++")
        AssertSourceDetailsEquals(
            getSourceLocation(for: postfix, from: instanceUnderTest),
            start: (1, 0, 20),
            end: (1, 20, 40),
            source: "postfix operator +++"
        )

        // infix
        let infix = instanceUnderTest.operators[2]
        XCTAssertEqual(infix.name, "+++")
        XCTAssertEqual(infix.kind, .infix)
        XCTAssertEqual(infix.description, "infix operator +++")
        AssertSourceDetailsEquals(
            getSourceLocation(for: infix, from: instanceUnderTest),
            start: (2, 0, 41),
            end: (2, 18, 59),
            source: "infix operator +++"
        )
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        prefix operator +++
        """#
        let sourceTwo = #"""
        prefix operator +++
        """#
        let sourceThree = #"""
        prefix operator +++
        postfix operator +++
        infix operator +++
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.operators.count, 1)

        let sampleOne = instanceUnderTest.operators[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.operators.count, 1)

        let sampleTwo = instanceUnderTest.operators[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.operators.count, 3)

        let sampleThree = instanceUnderTest.operators[0]
        let sampleFour = instanceUnderTest.operators[1]
        let otherSample = instanceUnderTest.operators[2]

        let equalCases: [(Operator, Operator)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Operator, Operator)] = [
            (sampleOne, sampleFour),
            (sampleOne, otherSample),
            (sampleTwo, sampleFour),
            (sampleTwo, otherSample),
            (sampleThree, sampleFour),
            (sampleThree, otherSample),
        ]
        equalCases.forEach {
            XCTAssertEqual($0.0, $0.1)
            XCTAssertEqual($0.0.hashValue, $0.1.hashValue)
        }
        notEqualCases.forEach {
            XCTAssertNotEqual($0.0, $0.1)
            XCTAssertNotEqual($0.0.hashValue, $0.1.hashValue)
        }
    }
}
