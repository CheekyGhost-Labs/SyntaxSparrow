//
//  DeinitializerTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class DeinitializerTests: XCTestCase {
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

    func test_enumeration_withAttributesAndModifiers() throws {
        let source = #"""
        @available(iOS 15, *)
        public enum MyEnum: String, Codable {
            case one, two
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]

        XCTAssertEqual(enumUnderTest.keyword, "enum")
        XCTAssertEqual(enumUnderTest.name, "MyEnum")
        XCTAssertEqual(enumUnderTest.inheritance, ["String", "Codable"])
        XCTAssertSourceStartPositionEquals(enumUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(enumUnderTest.sourceLocation, (3, 1, 79))
        XCTAssertEqual(
            enumUnderTest.extractFromSource(source),
            "@available(iOS 15, *)\npublic enum MyEnum: String, Codable {\n    case one, two\n}"
        )

        // Test attributes
        XCTAssertEqual(enumUnderTest.attributes.count, 1)
        let attributeUnderTest = enumUnderTest.attributes[0]
        XCTAssertEqual(attributeUnderTest.name, "available")

        // Test modifiers
        XCTAssertEqual(enumUnderTest.modifiers.count, 1)
        XCTAssertEqual(enumUnderTest.modifiers[0].name, "public")

        // Test cases
        XCTAssertEqual(enumUnderTest.cases.count, 2)
        XCTAssertEqual(enumUnderTest.cases[0].name, "one")
        XCTAssertEqual(enumUnderTest.cases[1].name, "two")
    }

    func test_enumeration_case_withAssociatedValuesAndRawValues() throws {
        let source = #"""
        public enum MyEnum: String {
            case one(value: Int)
            case two = "TWO"
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]

        // Test cases
        XCTAssertEqual(enumUnderTest.cases.count, 2)
        XCTAssertSourceStartPositionEquals(enumUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(enumUnderTest.sourceLocation, (3, 1, 76))
        XCTAssertEqual(
            enumUnderTest.extractFromSource(source),
            "public enum MyEnum: String {\n    case one(value: Int)\n    case two = \"TWO\"\n}"
        )

        // Test case with associated value
        let caseOneUnderTest = enumUnderTest.cases[0]
        XCTAssertEqual(caseOneUnderTest.name, "one")
        XCTAssertEqual(caseOneUnderTest.associatedValues?.count, 1)
        XCTAssertEqual(caseOneUnderTest.associatedValues?[0].name, "value")
        XCTAssertEqual(caseOneUnderTest.associatedValues?[0].type, .simple("Int", false))
        XCTAssertNil(caseOneUnderTest.rawValue)

        // Test case with raw value
        let caseTwoUnderTest = enumUnderTest.cases[1]
        XCTAssertEqual(caseTwoUnderTest.name, "two")
        XCTAssertNil(caseTwoUnderTest.associatedValues)
        XCTAssertEqual(caseTwoUnderTest.rawValue, "\"TWO\"")
    }

    func test_enumeration_withAllChildDeclarations() throws {
        let source = #"""
        public enum MyEnum: String {
            case one
            case two

            struct NestedStruct {}
            class NestedClass {}
            enum NestedEnum { case nested }
            typealias NestedTypeAlias = String
            func nestedFunction() {}
            var nestedVariable: Int = 0
            protocol NestedProtocol {}
            subscript(nestedSubscript idx: Int) -> Int { return idx }
            init(nestedInitializer: Int) {}
            deinit { print("Nested deinit") }
            infix operator +-: NestedOperator
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]
        XCTAssertEqual(enumUnderTest.cases.count, 2)

        // Check child structures
        XCTAssertEqual(enumUnderTest.declarationCollection.structures.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.structures[0].name, "NestedStruct")

        // Check child classes
        XCTAssertEqual(enumUnderTest.declarationCollection.classes.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.classes[0].name, "NestedClass")

        // Check child enums
        XCTAssertEqual(enumUnderTest.declarationCollection.enumerations.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.enumerations[0].name, "NestedEnum")

        // Check child type aliases
        XCTAssertEqual(enumUnderTest.declarationCollection.typealiases.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.typealiases[0].name, "NestedTypeAlias")

        // Check child functions
        XCTAssertEqual(enumUnderTest.declarationCollection.functions.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.functions[0].identifier, "nestedFunction")

        // Check child variables
        XCTAssertEqual(enumUnderTest.declarationCollection.variables.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.variables[0].name, "nestedVariable")

        // Check child protocols
        XCTAssertEqual(enumUnderTest.declarationCollection.protocols.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.protocols[0].name, "NestedProtocol")

        // Check child subscripts
        XCTAssertEqual(enumUnderTest.declarationCollection.subscripts.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.subscripts[0].keyword, "subscript")

        // Check child initializers
        XCTAssertEqual(enumUnderTest.declarationCollection.initializers.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.initializers[0].keyword, "init")

        // Check child deinitializers
        XCTAssertEqual(enumUnderTest.declarationCollection.deinitializers.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.deinitializers[0].keyword, "deinit")

        // Check child operators
        XCTAssertEqual(enumUnderTest.declarationCollection.operators.count, 1)
        XCTAssertEqual(enumUnderTest.declarationCollection.operators[0].name, "+-")
    }

    func test_enumeration_genericParameters() throws {
        let source = #"""
        public enum MyEnum<T: Equatable>: String {
            case one(T)
            case two(T)
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]
        XCTAssertEqual(enumUnderTest.genericParameters.count, 1)
        XCTAssertEqual(enumUnderTest.genericParameters[0].name, "T")
        XCTAssertEqual(enumUnderTest.genericParameters[0].type, "Equatable")
    }

    func test_enumeration_genericRequirements() throws {
        let source = #"""
        public enum MyEnum<T>: String where T: Hashable {
            case one(T)
            case two(T)
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]
        XCTAssertEqual(enumUnderTest.genericRequirements.count, 1)
        XCTAssertEqual(enumUnderTest.genericRequirements[0].leftTypeIdentifier, "T")
        XCTAssertEqual(enumUnderTest.genericRequirements[0].rightTypeIdentifier, "Hashable")
        XCTAssertEqual(enumUnderTest.genericRequirements[0].relation, .conformance)
    }

    func test_enumeration_case_withAttributes() throws {
        let source = #"""
        public enum MyEnum {
            case one
            @available(iOS 15, *)
            private case two
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let enumUnderTest = instanceUnderTest.enumerations[0]

        XCTAssertEqual(enumUnderTest.keyword, "enum")
        XCTAssertEqual(enumUnderTest.name, "MyEnum")
        XCTAssertEqual(enumUnderTest.inheritance, [])

        // Test case attributes
        let attributeExpectations: [(String?, String)] = [
            (nil, "iOS 15"),
            (nil, "*")
        ]
        XCTAssertEqual(enumUnderTest.cases.count, 2)
        XCTAssertEqual(enumUnderTest.cases[0].name, "one")
        XCTAssertEqual(enumUnderTest.cases[0].attributes, [])
        XCTAssertEqual(enumUnderTest.cases[1].modifiers.count, 1)
        XCTAssertEqual(enumUnderTest.cases[1].modifiers[0].name, "private")
        XCTAssertEqual(enumUnderTest.cases[1].name, "two")
        XCTAssertEqual(enumUnderTest.cases[1].attributes.count, 1)
        XCTAssertAttributesArgumentsEqual(enumUnderTest.cases[1].attributes[0], attributeExpectations)
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        public enum MyEnum: String {
            case sample
        }
        """#
        let sourceTwo = #"""
        public enum MyEnum: String {
            case sample
        }
        """#
        let sourceThree = #"""
        public enum MyEnum: String {
            case sample
        }
        public enum MyEnum: String {
            case test
        }
        public enum MyEnum: String {
            case testing
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let sampleOne = instanceUnderTest.enumerations[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)

        let sampleTwo = instanceUnderTest.enumerations[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 3)

        let sampleThree = instanceUnderTest.enumerations[0]
        let sampleFour = instanceUnderTest.enumerations[1]
        let otherSample = instanceUnderTest.enumerations[2]

        let equalCases: [(Enumeration, Enumeration)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(Enumeration, Enumeration)] = [
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

    // TODO: Case tests
}
