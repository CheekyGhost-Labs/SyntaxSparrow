//
//  PrecedenceGroupTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class PrecedenceGroupTests: XCTestCase {
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

    func test_precedenceGroup_allProperties_assignmentTrue_willResolveExpectedValues() {
        let source = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        infix operator ≈:CongruentPrecedence
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let group = instanceUnderTest.precedenceGroups[0]
        XCTAssertEqual(group.keyword, "precedencegroup")
        XCTAssertEqual(group.name, "CongruentPrecedence")
        XCTAssertEqual(group.assignment, true)
        XCTAssertEqual(group.associativity, .left)
        XCTAssertEqual(
            group.relations,
            [
                .lowerThan(["MultiplicationPrecedence"]),
                .higherThan(["AdditionPrecedence"]),
            ]
        )
        AssertSourceDetailsEquals(
            getSourceLocation(for: group, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (5, 1, 159),
            source: #"""
            precedencegroup CongruentPrecedence {
                lowerThan: MultiplicationPrecedence
                higherThan: AdditionPrecedence
                associativity: left
                assignment: true
            }
            """#
        )
    }

    func test_precedenceGroup_allProperties_assignmentFalse_willResolveExpectedValues() {
        let source = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: false
        }
        infix operator ≈:CongruentPrecedence
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let group = instanceUnderTest.precedenceGroups[0]
        XCTAssertEqual(group.keyword, "precedencegroup")
        XCTAssertEqual(group.name, "CongruentPrecedence")
        XCTAssertEqual(group.assignment, false)
        XCTAssertEqual(group.associativity, .left)
        XCTAssertEqual(
            group.relations,
            [
                .lowerThan(["MultiplicationPrecedence"]),
                .higherThan(["AdditionPrecedence"]),
            ]
        )
    }

    func test_precedenceGroup_noAssignment_willResolveExpectedValues() {
        let source = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
        }
        infix operator ≈:CongruentPrecedence
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let group = instanceUnderTest.precedenceGroups[0]
        XCTAssertEqual(group.keyword, "precedencegroup")
        XCTAssertEqual(group.name, "CongruentPrecedence")
        XCTAssertNil(group.assignment)
        XCTAssertEqual(group.associativity, .left)
        XCTAssertEqual(
            group.relations,
            [
                .lowerThan(["MultiplicationPrecedence"]),
                .higherThan(["AdditionPrecedence"]),
            ]
        )
    }

    func test_precedenceGroup_noAssociativity_willResolveExpectedValues() {
        let source = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
        }
        infix operator ≈:CongruentPrecedence
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let group = instanceUnderTest.precedenceGroups[0]
        XCTAssertEqual(group.keyword, "precedencegroup")
        XCTAssertEqual(group.name, "CongruentPrecedence")
        XCTAssertNil(group.assignment)
        XCTAssertNil(group.associativity)
        XCTAssertEqual(
            group.relations,
            [
                .lowerThan(["MultiplicationPrecedence"]),
                .higherThan(["AdditionPrecedence"]),
            ]
        )
    }

    func test_precedenceGroup_noRelations_willResolveExpectedValues() {
        let source = #"""
        precedencegroup CongruentPrecedence {
            associativity: left
            assignment: false
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let group = instanceUnderTest.precedenceGroups[0]
        XCTAssertEqual(group.keyword, "precedencegroup")
        XCTAssertEqual(group.name, "CongruentPrecedence")
        XCTAssertEqual(group.assignment, false)
        XCTAssertEqual(group.associativity, .left)
        XCTAssertEqual(group.relations, [])
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        """#
        let sourceTwo = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        """#
        let sourceThree = #"""
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        precedencegroup OtherPrecedence {
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        precedencegroup AlternatePrecedence {
            lowerThan: MultiplicationPrecedence
            associativity: left
            assignment: true
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let sampleOne = instanceUnderTest.precedenceGroups[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 1)

        let sampleTwo = instanceUnderTest.precedenceGroups[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.precedenceGroups.count, 3)

        let sampleThree = instanceUnderTest.precedenceGroups[0]
        let sampleFour = instanceUnderTest.precedenceGroups[1]
        let otherSample = instanceUnderTest.precedenceGroups[2]

        let equalCases: [(PrecedenceGroup, PrecedenceGroup)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(PrecedenceGroup, PrecedenceGroup)] = [
            (sampleOne, sampleFour),
            (sampleOne, otherSample),
            (sampleTwo, sampleFour),
            (sampleTwo, otherSample),
            (sampleThree, sampleFour),
            (sampleThree, otherSample)
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
