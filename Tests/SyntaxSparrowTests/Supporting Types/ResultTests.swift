//
//  ResultTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ResultTests: XCTestCase {
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

    func test_successTypeIsOptional_willResolveExpectedFlag() throws {
        let source = #"""
        typealias Example = Result<String, Error>
        typealias Example = Result<String?, Error>
        typealias Example = Result<() -> Void, Error>
        typealias Example = Result<(() -> Void)?, Error>
        typealias Example = Result<(name: String, age: Int), Error>
        typealias Example = Result<(name: String, age: Int)?, Error>
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 6)

        let results = instanceUnderTest.typealiases.map(\.initializedType)

        for i in 0..<4 {
            if case let EntityType.result(wrappedResult) = results[i] {
                switch i {
                case 0:
                    XCTAssertEqual(wrappedResult.successType, .simple("String"))
                    XCTAssertFalse(wrappedResult.successTypeIsOptional)
                case 1:
                    XCTAssertEqual(wrappedResult.successType, .simple("String?"))
                    XCTAssertTrue(wrappedResult.successTypeIsOptional)
                case 2:
                    XCTAssertTrue(wrappedResult.successType.isClosure)
                    XCTAssertFalse(wrappedResult.successTypeIsOptional)
                case 3:
                    XCTAssertTrue(wrappedResult.successType.isClosure)
                    XCTAssertTrue(wrappedResult.successTypeIsOptional)
                case 4:
                    XCTAssertTrue(wrappedResult.successType.isTuple)
                    XCTAssertFalse(wrappedResult.successTypeIsOptional)
                case 5:
                    XCTAssertTrue(wrappedResult.successType.isTuple)
                    XCTAssertTrue(wrappedResult.successTypeIsOptional)
                default:
                    break
                }
            } else {
                XCTFail("Should have result object")
            }
        }
    }
}
