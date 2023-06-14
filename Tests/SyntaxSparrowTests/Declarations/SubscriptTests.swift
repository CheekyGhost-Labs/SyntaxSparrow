//
//  SubscriptTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class SubscriptTests: XCTestCase {
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

    // attributes
    func test_subscript_withAttributes_willResolveExpectedValues() {
        let attributeExpectations: [(String?, String)] = [
            (nil, "*"),
            (nil, "unavailable"),
            ("message", "\"my message\""),
        ]
        let source = #"""
        @available(*, unavailable, message: "my message")
        subscript(_ index: Int) -> Int? {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)
        // Main
        let subscriptUnderTest = instanceUnderTest.subscripts[0]
        XCTAssertEqual(subscriptUnderTest.keyword, "subscript")
        let attributes = subscriptUnderTest.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertAttributesArgumentsEqual(attributes, attributeExpectations)
        AssertSourceDetailsEquals(
            getSourceLocation(for: subscriptUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 34, 84),
            source: "@available(*, unavailable, message: \"my message\")\nsubscript(_ index: Int) -> Int? {}"
        )
    }

    func test_subscript_withModifiers_willResolveExpectedValues() {
        let source = #"""
        public subscript(_ index: Int) -> Int? {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)
        // Main
        let subscriptUnderTest = instanceUnderTest.subscripts[0]
        XCTAssertEqual(subscriptUnderTest.keyword, "subscript")
        XCTAssertEqual(subscriptUnderTest.modifiers.map(\.name), ["public"])
        AssertSourceDetailsEquals(
            getSourceLocation(for: subscriptUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 41, 41),
            source: "public subscript(_ index: Int) -> Int? {}"
        )
    }

    func test_subscript_withGenericParameters_willResolveExpectedValues() {
        let source = #"""
        subscript<T: Equatable & Comparable, U>(_ index: T) -> U? where U: Hashable {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)
        // Main
        let subscriptUnderTest = instanceUnderTest.subscripts[0]
        XCTAssertEqual(subscriptUnderTest.keyword, "subscript")
        // Check generic parameters
        XCTAssertEqual(subscriptUnderTest.genericParameters.count, 2)
        let firstGenericParam = subscriptUnderTest.genericParameters[0]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertEqual(firstGenericParam.type, "Equatable & Comparable") // Explicit type in this context
        let secondGenericParam = subscriptUnderTest.genericParameters[1]
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(subscriptUnderTest.genericRequirements.count, 1)

        let genericRequirement = subscriptUnderTest.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "U")
        XCTAssertEqual(genericRequirement.relation, .conformance)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "Hashable")
    }

    func test_subscript_withGenericParameters_sameType_willResolveExpectedValues() {
        let source = #"""
        subscript<T, U>(_ index: T) -> U?  where T == U {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)
        // Main
        let subscriptUnderTest = instanceUnderTest.subscripts[0]
        XCTAssertEqual(subscriptUnderTest.keyword, "subscript")
        // Check generic parameters
        XCTAssertEqual(subscriptUnderTest.genericParameters.count, 2)
        let firstGenericParam = subscriptUnderTest.genericParameters[0]
        let secondGenericParam = subscriptUnderTest.genericParameters[1]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertNil(firstGenericParam.type) // No explicit type in this context
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(subscriptUnderTest.genericRequirements.count, 1)

        let genericRequirement = subscriptUnderTest.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "T")
        XCTAssertEqual(genericRequirement.relation, .sameType)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "U")
    }

    func test_subscript_accessors_willResolveExpectedValues() {
        let source = #"""
        subscript(index: Int) -> Int { 0 }
        subscript(index: Int) -> Int {
            get { 0 }
        }
        subscript(index: Int) -> Int {
            get { 0 }
            set { 0 }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 3)
        // Main
        XCTAssertEqual(instanceUnderTest.subscripts[0].accessors.map(\.kind?.rawValue), []) // Technically getter but going w code accuracy
        XCTAssertEqual(instanceUnderTest.subscripts[1].accessors.map(\.kind?.rawValue), ["get"])
        XCTAssertEqual(instanceUnderTest.subscripts[2].accessors.map(\.kind?.rawValue), ["get", "set"])
    }

    func test_subscript_indicies_willResolveExpectedValues() throws {
        let source = #"""
        subscript(_ index: Int) -> Int {}
        subscript(name: String = "name") -> (name: String, age: Int)? {}
        subscript(name: String?, age: Int) -> String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 3)

        // First subscript
        // subscript(_ index: Int) -> Int {}
        let subscriptOne = instanceUnderTest.subscripts[0]
        XCTAssertEqual(subscriptOne.indices.count, 1)
        XCTAssertEqual(subscriptOne.indices[0].name, "_")
        XCTAssertEqual(subscriptOne.indices[0].secondName, "index")
        XCTAssertTrue(subscriptOne.indices[0].isLabelOmitted)
        XCTAssertFalse(subscriptOne.indices[0].isOptional)
        XCTAssertFalse(subscriptOne.indices[0].isVariadic)
        XCTAssertNil(subscriptOne.indices[0].defaultArgument)
        XCTAssertEqual(subscriptOne.indices[0].type, .simple("Int"))
        // First subscript: Output
        XCTAssertEqual(subscriptOne.returnType, .simple("Int"))

        // Second subscript
        // subscript(name: String = "name") -> (name: String, age: Int)? {}
        let subscriptTwo = instanceUnderTest.subscripts[1]
        XCTAssertEqual(subscriptTwo.indices.count, 1)
        XCTAssertEqual(subscriptTwo.indices[0].name, "name")
        XCTAssertNil(subscriptTwo.indices[0].secondName)
        XCTAssertFalse(subscriptTwo.indices[0].isLabelOmitted)
        XCTAssertFalse(subscriptTwo.indices[0].isOptional)
        XCTAssertFalse(subscriptTwo.indices[0].isVariadic)
        XCTAssertEqual(subscriptTwo.indices[0].defaultArgument, "\"name\"")
        XCTAssertEqual(subscriptTwo.indices[0].type, .simple("String"))
        // Second subscript: Output
        XCTAssertEqual(subscriptOne.returnType, .simple("Int"))
        // High level entity type check
        let tupleOutput = try XCTUnwrap(subscriptTwo.returnType)
        if case let EntityType.tuple(tuple) = tupleOutput {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertTrue(tuple.isOptional)
            XCTAssertEqual(tuple.elements[0].name, "name")
            XCTAssertEqual(tuple.elements[0].type, .simple("String"))
            XCTAssertEqual(tuple.elements[1].name, "age")
            XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
            // More extensive tests in other file for entity types
        } else {
            XCTFail("subscript should return a tuple")
        }

        // Third subscript
        // subscript(name: String?, age: Int) -> String {}
        let subscriptThree = instanceUnderTest.subscripts[2]
        XCTAssertEqual(subscriptThree.indices.count, 2)
        XCTAssertEqual(subscriptThree.indices[0].name, "name")
        XCTAssertNil(subscriptThree.indices[0].secondName)
        XCTAssertFalse(subscriptThree.indices[0].isLabelOmitted)
        XCTAssertTrue(subscriptThree.indices[0].isOptional)
        XCTAssertFalse(subscriptThree.indices[0].isVariadic)
        XCTAssertNil(subscriptThree.indices[0].defaultArgument)
        XCTAssertEqual(subscriptThree.indices[0].type, .simple("String?"))
        XCTAssertEqual(subscriptThree.indices[1].name, "age")
        XCTAssertNil(subscriptThree.indices[1].secondName)
        XCTAssertFalse(subscriptThree.indices[1].isLabelOmitted)
        XCTAssertFalse(subscriptThree.indices[1].isOptional)
        XCTAssertFalse(subscriptThree.indices[1].isVariadic)
        XCTAssertNil(subscriptThree.indices[1].defaultArgument)
        XCTAssertEqual(subscriptThree.indices[1].type, .simple("Int"))
        // Second subscript: Output
        XCTAssertEqual(subscriptThree.returnType, .simple("String"))
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        subscript(_ index: Int) -> Int? {}
        """#
        let sourceTwo = #"""
        subscript(_ index: Int) -> Int? {}
        """#
        let sourceThree = #"""
        subscript(_ index: Int) -> Int? {}
        public subscript(_ index: String) -> String {}
        public subscript(_ key: String) -> String? {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)

        let sampleOne = instanceUnderTest.subscripts[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 1)

        let sampleTwo = instanceUnderTest.subscripts[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 3)

        let sampleThree = instanceUnderTest.subscripts[0]
        let sampleFour = instanceUnderTest.subscripts[1]
        let otherSample = instanceUnderTest.subscripts[2]

        let equalCases: [(Subscript, Subscript)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Subscript, Subscript)] = [
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
