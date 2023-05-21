//
//  FunctionTests.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import XCTest
@testable import SyntaxSparrow

final class FunctionTests: XCTestCase {

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

    func test_standardDeclarations_willResolveExpectedProperties() throws {
        let source = #"""
        func sayHello(_ handler: ((String, Int)?)) { }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        try instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let function = instanceUnderTest.functions[0]
        let input = function.signature.input[0]
        switch input.type {
        case .closure(let closure):
            print(closure.isEscaping)
            print(closure.isAutoEscaping)
            print(closure.isOptional)
        case .tuple(let tuple):
            print(tuple.isOptional)
        default:
            break
        }
    }

    func sayHello(_ handler: ((((String)) -> String))) { }
}
