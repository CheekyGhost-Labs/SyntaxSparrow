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

        let cases = switchExpr.cases
        cases.forEach {
            switch $0 {
            case .switchCase(let switchCase):
                _ = switchCase.items
            case .ifConfig:
                break
            }
        }
    }
}
