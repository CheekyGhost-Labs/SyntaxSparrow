//
//  ChildCollectingTests.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import XCTest
@testable import SyntaxSparrow

final class ChildCollectingTests: XCTestCase {

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

    func test_struct_willResolveExpectedCollection() throws {
        let source = #"""
        struct MyStruct {
          struct Nested {}
          class Nested {}
          enum Nested {}
          typealias Nested = String
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        try instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)
        // A
        let declaration = instanceUnderTest.structures[0]
        // Children
        XCTAssertEqual(declaration.structures.count, 1)
        XCTAssertEqual(declaration.classes.count, 1)
        XCTAssertEqual(declaration.enumerations.count, 1)
        XCTAssertEqual(declaration.typealiases.count, 1)
    }

    func test_extension_willResolveExpectedCollection() throws {
        let source = #"""
        extension String {
          struct Nested {}
          class Nested {}
          enum Nested {}
          typealias Nested = String
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        try instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)
        // A
        let declaration = instanceUnderTest.extensions[0]
        // Children
        XCTAssertEqual(declaration.structures.count, 1)
        XCTAssertEqual(declaration.classes.count, 1)
        XCTAssertEqual(declaration.enumerations.count, 1)
        XCTAssertEqual(declaration.typealiases.count, 1)
    }
}
