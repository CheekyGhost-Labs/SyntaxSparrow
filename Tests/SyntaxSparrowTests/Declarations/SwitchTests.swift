//
//  FunctionTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class SwitchTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_switch_simpleIdentifier_withResolveExpectedValues() throws {
        let source = #"""
        switch target {
          case .example:
            print("placeholder")
          case .example(let items), let .other(items):
            print("placeholder")
          case let .example(items):
            print("placeholder")
          case let example as SomeItem:
              print("placeholder")
          case let example as? SomeItem:
              print("placeholder")
          case is SomeType:
              print("placeholder")
          @unknown default:
            print("placeholder")
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.switches.count, 1)

        let switchExpr = instanceUnderTest.switches[0]
        XCTAssertEqual(switchExpr.keyword, "switch")
        XCTAssertEqual(switchExpr.cases.count, 7)
        XCTAssertEqual(switchExpr.expression, .identifier(identifier: "target"))

        // case .example:
        guard case let SwitchExpression.Case.switchCase(switchCaseOne) = switchExpr.cases[0] else {
            XCTFail("The first case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseOne.label, .case)
        XCTAssertEqual(switchCaseOne.label.description, "case")
        XCTAssertNil(switchCaseOne.attribute)
        XCTAssertEqual(switchCaseOne.items.count, 1)
        XCTAssertEqual(switchCaseOne.items[0], .member(name: "example"))

        // case .example(let items), let .other(items):
        guard case let SwitchExpression.Case.switchCase(switchCaseTwo) = switchExpr.cases[1] else {
            XCTFail("The second case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseTwo.label, .case)
        XCTAssertEqual(switchCaseTwo.label.description, "case")
        XCTAssertNil(switchCaseTwo.attribute)
        XCTAssertEqual(switchCaseTwo.items.count, 2)
        XCTAssertEqual(switchCaseTwo.items[0], .innerValueBindingMember(name: "example", elements: ["let": "items"]))
        XCTAssertEqual(switchCaseTwo.items[1], .valueBindingMember(keyWord: "let", name: "other", elements: ["items"]))

        // case let .example(items):
        guard case let SwitchExpression.Case.switchCase(switchCaseThree) = switchExpr.cases[2] else {
            XCTFail("The third case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseThree.label, .case)
        XCTAssertEqual(switchCaseThree.label.description, "case")
        XCTAssertNil(switchCaseThree.attribute)
        XCTAssertEqual(switchCaseThree.items.count, 1)
        XCTAssertEqual(switchCaseThree.items[0], .valueBindingMember(keyWord: "let", name: "example", elements: ["items"]))

        // case let example as SomeItem:
        guard case let SwitchExpression.Case.switchCase(switchCaseFour) = switchExpr.cases[3] else {
            XCTFail("The fourth case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseFour.label, .case)
        XCTAssertEqual(switchCaseFour.label.description, "case")
        XCTAssertNil(switchCaseFour.attribute)
        XCTAssertEqual(switchCaseFour.items.count, 1)
        XCTAssertEqual(switchCaseFour.items[0], .valueBinding(keyWord: "let", elements: ["example", "as", "SomeItem"]))

        // case let example as? SomeItem:
        guard case let SwitchExpression.Case.switchCase(switchCaseFour) = switchExpr.cases[4] else {
            XCTFail("The fourth case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseFour.label, .case)
        XCTAssertEqual(switchCaseFour.label.description, "case")
        XCTAssertNil(switchCaseFour.attribute)
        XCTAssertEqual(switchCaseFour.items.count, 1)
        XCTAssertEqual(switchCaseFour.items[0], .valueBinding(keyWord: "let", elements: ["example", "as?", "SomeItem"]))

        // case is SomeType:
        guard case let SwitchExpression.Case.switchCase(switchCaseFive) = switchExpr.cases[5] else {
            XCTFail("The fifth case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseFive.label, .case)
        XCTAssertEqual(switchCaseFive.label.description, "case")
        XCTAssertNil(switchCaseFive.attribute)
        XCTAssertEqual(switchCaseFive.items.count, 1)
        XCTAssertEqual(switchCaseFive.items[0], .isTypePattern(type: "SomeType"))

        // @unknown default:
        guard case let SwitchExpression.Case.switchCase(switchCaseSix) = switchExpr.cases[6] else {
            XCTFail("The fifth case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseSix.label, .default)
        XCTAssertEqual(switchCaseSix.label.description, "default")
        XCTAssertEqual(switchCaseSix.attribute?.name, "unknown")
        XCTAssertEqual(switchCaseSix.attribute?.arguments, [])
        XCTAssertEqual(switchCaseSix.items.count, 0)
    }

    func test_switch_tupleIdentifier_withResolveExpectedValues() throws {
        let source = #"""
        switch (lhs, rhs) {
          case (true, false):
            print("placeholder")
          default:
            print("placeholder")
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.switches.count, 1)

        let switchExpr = instanceUnderTest.switches[0]
        XCTAssertEqual(switchExpr.keyword, "switch")
        XCTAssertEqual(switchExpr.cases.count, 2)
        XCTAssertEqual(switchExpr.expression, .tuple(elements: ["lhs", "rhs"]))

        // case (true, false):
        guard case let SwitchExpression.Case.switchCase(switchCaseOne) = switchExpr.cases[0] else {
            XCTFail("The first case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseOne.label, .case)
        XCTAssertEqual(switchCaseOne.label.description, "case")
        XCTAssertNil(switchCaseOne.attribute)
        XCTAssertEqual(switchCaseOne.items.count, 1)
        XCTAssertEqual(switchCaseOne.items[0], .tuple(elements: ["true", "false"]))

        // default:
        guard case let SwitchExpression.Case.switchCase(switchCaseFive) = switchExpr.cases[1] else {
            XCTFail("The second case in the switch body should be the `switchCase` type")
            return
        }
        XCTAssertEqual(switchCaseFive.label, .default)
        XCTAssertEqual(switchCaseFive.label.description, "default")
        XCTAssertNil(switchCaseFive.attribute)
        XCTAssertEqual(switchCaseFive.items.count, 0)
    }
}
