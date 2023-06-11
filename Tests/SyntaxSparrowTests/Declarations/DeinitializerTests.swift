//
//  EnumerationTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class EnumerationTests: XCTestCase {
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

    func test_initializer_withAttributesAndModifiers() throws {
        let source = #"""
        class SomeClass {
            @available(iOS 15, *)
            public deinit() {}
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        XCTAssertEqual(instanceUnderTest.classes[0].deinitializers.count, 1)

        let deinitUnderTest = instanceUnderTest.classes[0].deinitializers[0]

        XCTAssertEqual(deinitUnderTest.keyword, "deinit")
        AssertSourceDetailsEquals(
            getSourceLocation(for: deinitUnderTest, from: instanceUnderTest),
            start: (1, 4, 22),
            end: (2, 22, 66),
            source: "@available(iOS 15, *)\n    public deinit() {}"
        )

        // Test attributes
        XCTAssertEqual(deinitUnderTest.attributes.count, 1)
        let attributeUnderTest = deinitUnderTest.attributes[0]
        XCTAssertEqual(attributeUnderTest.name, "available")

        // Test modifiers
        XCTAssertEqual(deinitUnderTest.modifiers.count, 1)
        XCTAssertEqual(deinitUnderTest.modifiers[0].name, "public")
    }

    func test_basic_willResolveExpectedProperties() throws {
        let source = #"""
        public deinit() {
            struct NestedStruct {}
            class NestedClass {}
            enum NestedEnum { case nested }
            typealias NestedTypeAlias = String
            func nestedFunction() {}
            var nestedVariable: Int = 0
            protocol NestedProtocol {}
            subscript(nestedSubscript idx: Int) -> Int { return idx }
            deinit { print("Nested deinit") }
            infix operator +-: NestedOperator
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.deinitializers.count, 1)
        // Test instance
        let deinitUnderTest = instanceUnderTest.deinitializers[0]
        // Children
        XCTAssertEqual(deinitUnderTest.structures.count, 1)
        XCTAssertEqual(deinitUnderTest.structures[0].name, "NestedStruct")
        XCTAssertEqual(deinitUnderTest.classes.count, 1)
        XCTAssertEqual(deinitUnderTest.classes[0].name, "NestedClass")
        XCTAssertEqual(deinitUnderTest.enumerations.count, 1)
        XCTAssertEqual(deinitUnderTest.enumerations[0].name, "NestedEnum")
        XCTAssertEqual(deinitUnderTest.typealiases.count, 1)
        XCTAssertEqual(deinitUnderTest.typealiases[0].name, "NestedTypeAlias")
        XCTAssertEqual(deinitUnderTest.functions.count, 1)
        XCTAssertEqual(deinitUnderTest.functions[0].identifier, "nestedFunction")
        XCTAssertEqual(deinitUnderTest.variables.count, 1)
        XCTAssertEqual(deinitUnderTest.variables[0].name, "nestedVariable")
        XCTAssertEqual(deinitUnderTest.protocols.count, 1)
        XCTAssertEqual(deinitUnderTest.protocols[0].name, "NestedProtocol")
        XCTAssertEqual(deinitUnderTest.subscripts.count, 1)
        XCTAssertEqual(deinitUnderTest.subscripts[0].keyword, "subscript")
        XCTAssertEqual(deinitUnderTest.deinitializers.count, 1)
        XCTAssertEqual(deinitUnderTest.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(deinitUnderTest.operators.count, 1)
        XCTAssertEqual(deinitUnderTest.operators[0].name, "+-")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        deinit() {}
        """#
        let sourceTwo = #"""
        deinit() {}
        """#
        let sourceThree = #"""
        deinit() {}
        deinit() { let name = "name" }
        deinit() { let age = 0 }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.deinitializers.count, 1)

        let sampleOne = instanceUnderTest.deinitializers[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.deinitializers.count, 1)

        let sampleTwo = instanceUnderTest.deinitializers[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.deinitializers.count, 3)

        let sampleThree = instanceUnderTest.deinitializers[0]
        let sampleFour = instanceUnderTest.deinitializers[1]
        let otherSample = instanceUnderTest.deinitializers[2]

        let equalCases: [(Deinitializer, Deinitializer)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(Deinitializer, Deinitializer)] = [
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
