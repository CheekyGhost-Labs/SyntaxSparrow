//
//  ClassTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ExtensionTests: XCTestCase {
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

    func test_basic_willResolveExpectedProperties() throws {
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
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)
        // A
        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.extendedType, "String")
        XCTAssertEqual(extensionUnderTest.keyword, "extension")
        XCTAssertEqual(extensionUnderTest.modifiers.count, 0)
        XCTAssertEqual(extensionUnderTest.attributes.count, 0)
        XCTAssertSourceStartPositionEquals(extensionUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(extensionUnderTest.sourceLocation, (5, 1, 102))
        XCTAssertEqual(extensionUnderTest.extractFromSource(source), source)
    }

    func test_extensionWithAttributes() throws {
        let source = #"""
        @available(iOS 15, *)
        extension String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.attributes.count, 1)
        XCTAssertEqual(extensionUnderTest.attributes[0].name, "available")
        XCTAssertAttributesArgumentsEqual(extensionUnderTest.attributes[0], [
            (nil, "iOS 15"),
            (nil, "*"),
        ])
        XCTAssertEqual(extensionUnderTest.attributes[0].description, "@available(iOS 15, *)")
        XCTAssertSourceStartPositionEquals(extensionUnderTest.sourceLocation, (line: 0, column: 0, utf8Offset: 0))
        XCTAssertSourceEndPositionEquals(extensionUnderTest.sourceLocation, (line: 1, column: 19, utf8Offset: 41))
    }

    func test_extensionWithModifiers() throws {
        let source = #"""
        public extension String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.modifiers.count, 1)
        XCTAssertEqual(extensionUnderTest.modifiers[0].name, "public")
        XCTAssertSourceStartPositionEquals(extensionUnderTest.sourceLocation, (line: 0, column: 0, utf8Offset: 0))
        XCTAssertSourceEndPositionEquals(extensionUnderTest.sourceLocation, (line: 0, column: 26, utf8Offset: 26))
    }

    func test_extensionWithInheritance() throws {
        let source = #"""
        protocol A {}
        protocol B {}
        extension String: A, B {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.inheritance.count, 2)
        XCTAssertEqual(extensionUnderTest.inheritance[0], "A")
        XCTAssertEqual(extensionUnderTest.inheritance[1], "B")
    }

    func test_extensionWithGenericRequirements() throws {
        let source = #"""
        extension Array where Element: Comparable {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.genericRequirements.count, 1)
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].relation, .conformance)
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].leftTypeIdentifier, "Element")
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].rightTypeIdentifier, "Comparable")
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].description, "Element: Comparable")
        XCTAssertSourceStartPositionEquals(extensionUnderTest.sourceLocation, (line: 0, column: 0, utf8Offset: 0))
        XCTAssertSourceEndPositionEquals(extensionUnderTest.sourceLocation, (line: 0, column: 44, utf8Offset: 44))
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        extension String {}
        """#
        let sourceTwo = #"""
        extension String {}
        """#
        let sourceThree = #"""
        extension String {}
        public extension String {}
        extension CustomType {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let sampleOne = instanceUnderTest.extensions[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let sampleTwo = instanceUnderTest.extensions[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 3)

        let sampleThree = instanceUnderTest.extensions[0]
        let sampleFour = instanceUnderTest.extensions[1]
        let otherSample = instanceUnderTest.extensions[2]

        let equalCases: [(Extension, Extension)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Extension, Extension)] = [
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
