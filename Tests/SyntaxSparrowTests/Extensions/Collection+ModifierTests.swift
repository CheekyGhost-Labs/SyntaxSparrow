//
//  Collection+ModifierTests.swift
//  
//
//  Created by Michael O'Brien on 10/5/2024.
//

import Foundation
@testable import SyntaxSparrow
import XCTest

final class CollectionModifierTests: XCTestCase {

    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    // MARK: - Tests

    func test_basicFunctionality_willReturnExpectedResults() {
        let source = #"""
        public final fileprivate class Example {}
        private(set) var name: String = "name"
        fileprivate(set) public var name: String = "name"
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let aClass = instanceUnderTest.classes[0]
        XCTAssertTrue(aClass.modifiers.containsKeyword(.public))
        XCTAssertTrue(aClass.modifiers.containsKeyword(.final))
        XCTAssertTrue(aClass.modifiers.containsKeyword(.fileprivate))
        XCTAssertFalse(aClass.modifiers.containsKeyword(.open))

        var variable = instanceUnderTest.variables[0]
        XCTAssertFalse(variable.modifiers.containsKeyword(.public))
        XCTAssertFalse(variable.modifiers.containsKeyword(.final))
        XCTAssertFalse(variable.modifiers.containsKeyword(.private))
        XCTAssertTrue(variable.modifiers.containsKeyword(.private, withDetail: "set"))
        XCTAssertFalse(variable.modifiers.containsKeyword(.fileprivate))
        XCTAssertFalse(variable.modifiers.containsKeyword(.fileprivate, withDetail: "set"))

        variable = instanceUnderTest.variables[1]
        XCTAssertTrue(variable.modifiers.containsKeyword(.public))
        XCTAssertFalse(variable.modifiers.containsKeyword(.final))
        XCTAssertFalse(variable.modifiers.containsKeyword(.private))
        XCTAssertFalse(variable.modifiers.containsKeyword(.private, withDetail: "set"))
        XCTAssertFalse(variable.modifiers.containsKeyword(.fileprivate))
        XCTAssertTrue(variable.modifiers.containsKeyword(.fileprivate, withDetail: "set"))
    }
}
