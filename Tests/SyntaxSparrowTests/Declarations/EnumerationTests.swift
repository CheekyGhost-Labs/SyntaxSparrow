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
        XCTAssertEqual(caseOneUnderTest.associatedValues.count, 1)
        XCTAssertEqual(caseOneUnderTest.associatedValues[0].name, "value")
        XCTAssertEqual(caseOneUnderTest.associatedValues[0].type, .simple("Int"))
        XCTAssertNil(caseOneUnderTest.rawValue)

        // Test case with raw value
        let caseTwoUnderTest = enumUnderTest.cases[1]
        XCTAssertEqual(caseTwoUnderTest.name, "two")
        XCTAssertEqual(caseTwoUnderTest.associatedValues, [])
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

    func test_cases_associatedValues_willResolveExptectedTypes() throws {
        let source = #"""
        enum MyEnum {
            case noParameters()
            case labelOmitted(_ name: String)
            case singleName(name: String)
            case singleNameOptional(name: String?)
            case twoNames(withName name: String)
            case optionalSimple(_ name: String?)
            case variadic(names: String...)
            case variadicOptional(_ names: String?...)
            case multipleParameters(name: String, age: Int?)
            case throwing(name: String, age: Int?) throws
            case tuple(person: (name: String, age: Int?)?)
            case closure(_ handler: (Int) -> Void)
            case autoEscapingClosure(_ handler: ((Int) -> Void)?)
            case complexClosure(_ handler: ((name: String, age: Int) -> String?)?)
            case result(processResult: Result<String, Error>)
            case resultOptional(processResult: Result<String, Error>?)
            case defaultValue(name: String = "name")
            case inoutValue(names: inout [String])
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)
        XCTAssertEqual(instanceUnderTest.enumerations[0].cases.count, 18)
        let enumeration = instanceUnderTest.enumerations[0]

        // No Parameters
        // case noParameters()
        var enumCase = enumeration.cases[0]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "noParameters")
        XCTAssertEqual(enumCase.associatedValues, [])

        // Label Omitted
        // case labelOmitted(_ name: String)
        enumCase = enumeration.cases[1]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "labelOmitted")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "name")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ name: String")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // Single Name
        // case singleName(name: String)
        enumCase = enumeration.cases[2]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "singleName")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "name")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].description, "name: String")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // Single Name Optional
        // case singleNameOptional(name: String?)
        enumCase = enumeration.cases[3]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "singleNameOptional")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "name")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String?"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, true)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "name: String?")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // Two Names
        // case twoNames(withName name: String)
        enumCase = enumeration.cases[4]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "twoNames")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "withName")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "name")
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].description, "withName name: String")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // optionalSimple
        // case optionalSimple(_ name: String?)
        enumCase = enumeration.cases[5]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "optionalSimple")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "name")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String?"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, true)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ name: String?")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // variadic
        // case variadic(name: String...)
        enumCase = enumeration.cases[6]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "variadic")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "names")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertTrue(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String..."))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String...") // see if can get ellipsis
        XCTAssertEqual(enumCase.associatedValues[0].description, "names: String...")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // variadic optional
        // case variadicOptional(_ names: String?...)
        enumCase = enumeration.cases[7]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "variadicOptional")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "names")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertTrue(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String?..."))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, true)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String?...") // see if can get ellipsis
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ names: String?...")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))

        // multiple parameters
        // case multipleParameters(name: String, age: Int?)
        enumCase = enumeration.cases[8]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "multipleParameters")
        XCTAssertEqual(enumCase.associatedValues.count, 2)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "name")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].description, "name: String")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))
        XCTAssertEqual(enumCase.associatedValues[1].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[1].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[1].name, "age")
        XCTAssertEqual(enumCase.associatedValues[1].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[1].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[1].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[1].type, .simple("Int?"))
        XCTAssertEqual(enumCase.associatedValues[1].isOptional, true)
        XCTAssertFalse(enumCase.associatedValues[1].isInOut)
        XCTAssertEqual(enumCase.associatedValues[1].rawType, "Int?")
        XCTAssertEqual(enumCase.associatedValues[1].description, "age: Int?")
        XCTAssertNotNil(enumCase.associatedValues[1].node.as(EnumCaseParameterSyntax.self))

        // multiple parameters throwing
        // case throwing(name: String, age: Int?) throws
        enumCase = enumeration.cases[9]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "throwing")
        XCTAssertEqual(enumCase.associatedValues.count, 2)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "name")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].isOptional, false)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].description, "name: String")
        XCTAssertNotNil(enumCase.associatedValues[0].node.as(EnumCaseParameterSyntax.self))
        XCTAssertEqual(enumCase.associatedValues[1].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[1].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[1].name, "age")
        XCTAssertEqual(enumCase.associatedValues[1].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[1].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[1].isVariadic)
        XCTAssertEqual(enumCase.associatedValues[1].type, .simple("Int?"))
        XCTAssertEqual(enumCase.associatedValues[1].isOptional, true)
        XCTAssertFalse(enumCase.associatedValues[1].isInOut)
        XCTAssertNil(enumCase.associatedValues[1].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[1].rawType, "Int?")
        XCTAssertEqual(enumCase.associatedValues[1].description, "age: Int?")
        XCTAssertNotNil(enumCase.associatedValues[1].node.as(EnumCaseParameterSyntax.self))

        // tuple parameter
        // case tuple(person: (name: String, age: Int?)?)
        enumCase = enumeration.cases[10]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "tuple")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "person")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, nil)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertTrue(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "(name: String, age: Int?)?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "person: (name: String, age: Int?)?")

        if case let EntityType.tuple(tuple) = enumCase.associatedValues[0].type {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertTrue(tuple.isOptional)
            XCTAssertEqual(tuple.elements[0].type, .simple("String"))
            XCTAssertEqual(tuple.elements[0].name, "name")
            XCTAssertNil(tuple.elements[0].secondName)
            XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
            XCTAssertEqual(tuple.elements[1].name, "age")
            XCTAssertNil(tuple.elements[1].secondName)
            XCTAssertTrue(tuple.elements[1].isOptional)
        } else {
            XCTFail("function.signature.input[0] type should be tuple")
        }

        // closure parameter
        // case closure(_ handler: (Int) -> Void)
        enumCase = enumeration.cases[11]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "closure")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes.map(\.name), [])
        XCTAssertEqual(enumCase.associatedValues[0].attributes.flatMap(\.arguments), [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "handler")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertFalse(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "(Int) -> Void")
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ handler: (Int) -> Void")

        if case let EntityType.closure(closure) = enumCase.associatedValues[0].type {
            XCTAssertEqual(closure.input, .simple("Int"))
            XCTAssertFalse(closure.isVoidInput)
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertFalse(closure.isOptional)
            XCTAssertFalse(closure.isEscaping)
            XCTAssertFalse(closure.isAutoEscaping)
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // auto escaping closure parameter
        // case autoEscapingClosure(_ handler: ((Int) -> Void)?)
        enumCase = enumeration.cases[12]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "autoEscapingClosure")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "handler")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertTrue(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "((Int) -> Void)?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ handler: ((Int) -> Void)?")

        if case let EntityType.closure(closure) = enumCase.associatedValues[0].type {
            XCTAssertEqual(closure.input, .simple("Int"))
            XCTAssertFalse(closure.isVoidInput)
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertTrue(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertTrue(closure.isAutoEscaping)
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // complex auto escaping closure
        // case complexClosure(_ handler: ((name: String, age: Int) -> String?)?)
        enumCase = enumeration.cases[13]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "complexClosure")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "_")
        XCTAssertEqual(enumCase.associatedValues[0].secondName, "handler")
        XCTAssertTrue(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertTrue(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "((name: String, age: Int) -> String?)?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "_ handler: ((name: String, age: Int) -> String?)?")

        if case let EntityType.closure(closure) = enumCase.associatedValues[0].type {
            XCTAssertEqual(closure.output, .simple("String?"))
            XCTAssertFalse(closure.isVoidOutput)
            XCTAssertTrue(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertTrue(closure.isAutoEscaping)
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
                XCTAssertFalse(tuple.isOptional)
            } else {
                XCTFail("closure input type should be tuple")
            }
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // Result parameter
        // case result(processResult: Result<String, Error>)
        enumCase = enumeration.cases[14]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "result")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "processResult")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertFalse(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "Result<String, Error>")
        XCTAssertEqual(enumCase.associatedValues[0].description, "processResult: Result<String, Error>")

        if case let EntityType.result(result) = enumCase.associatedValues[0].type {
            XCTAssertEqual(result.successType, .simple("String"))
            XCTAssertEqual(result.failureType, .simple("Error"))
            XCTAssertFalse(result.isOptional)
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // case resultOptional(processResult: Result<String, Error>?)
        enumCase = enumeration.cases[15]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "resultOptional")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "processResult")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertTrue(enumCase.associatedValues[0].isOptional)
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "Result<String, Error>?")
        XCTAssertEqual(enumCase.associatedValues[0].description, "processResult: Result<String, Error>?")

        if case let EntityType.result(result) = enumCase.associatedValues[0].type {
            XCTAssertEqual(result.successType, .simple("String"))
            XCTAssertEqual(result.failureType, .simple("Error"))
            XCTAssertTrue(result.isOptional)
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // case defaultValue(name: String = "name")
        enumCase = enumeration.cases[16]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "defaultValue")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "name")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertFalse(enumCase.associatedValues[0].isOptional)
        XCTAssertFalse(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "String")
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("String"))
        XCTAssertEqual(enumCase.associatedValues[0].defaultArgument, "\"name\"")
        XCTAssertEqual(enumCase.associatedValues[0].description, "name: String = \"name\"")

        // Optional Result parameter
        // case inoutValue(names: inout [String])
        enumCase = enumeration.cases[17]
        XCTAssertEqual(enumCase.keyword, "case")
        XCTAssertEqual(enumCase.name, "inoutValue")
        XCTAssertEqual(enumCase.associatedValues.count, 1)
        XCTAssertEqual(enumCase.associatedValues[0].attributes, [])
        XCTAssertEqual(enumCase.associatedValues[0].modifiers, [])
        XCTAssertEqual(enumCase.associatedValues[0].name, "names")
        XCTAssertNil(enumCase.associatedValues[0].secondName)
        XCTAssertFalse(enumCase.associatedValues[0].isLabelOmitted)
        XCTAssertFalse(enumCase.associatedValues[0].isVariadic)
        XCTAssertFalse(enumCase.associatedValues[0].isOptional)
        XCTAssertTrue(enumCase.associatedValues[0].isInOut)
        XCTAssertEqual(enumCase.associatedValues[0].rawType, "inout [String]")
        XCTAssertEqual(enumCase.associatedValues[0].type, .simple("[String]"))
        XCTAssertNil(enumCase.associatedValues[0].defaultArgument)
        XCTAssertEqual(enumCase.associatedValues[0].description, "names: inout [String]")
    }
}
