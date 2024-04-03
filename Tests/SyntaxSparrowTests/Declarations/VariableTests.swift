//
//  VariableTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class VariableTests: XCTestCase {
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

    // TODO: Tests

    func test_variable_mutable_willResolveExpectedValues() {
        let source = #"""
        var name: String? = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String?"))
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "\"name\"")
        XCTAssertTrue(variable.hasSetter)
    }

    func test_variable_immutable_willResolveExpectedValues() {
        let source = #"""
        let name: String?
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "let")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String?"))
        XCTAssertTrue(variable.isOptional)
        XCTAssertNil(variable.initializedValue)
        XCTAssertFalse(variable.hasSetter)
    }

    func test_variable_multiplePatternBindings_willResolveExpectedValues() {
        let source = #"""
        var firstName, lastName: String
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        var variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "firstName")
        XCTAssertEqual(variable.type, .simple("String"))
        XCTAssertFalse(variable.isOptional)
        XCTAssertTrue(variable.hasSetter)
        XCTAssertNil(variable.initializedValue)
        variable = instanceUnderTest.variables[1]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "lastName")
        XCTAssertEqual(variable.type, .simple("String"))
        XCTAssertFalse(variable.isOptional)
        XCTAssertTrue(variable.hasSetter)
        XCTAssertNil(variable.initializedValue)
    }

    // attributes
    // modifiers
    func test_variable_withAttributes_willResolveExpectedValues() {
        let attributeExpectations: [(String?, String)] = [
            (nil, "*"),
            (nil, "unavailable"),
            ("message", "\"my message\""),
        ]
        let source = #"""
        @available(*, unavailable, message: "my message")
        var name: String
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)
        // Main
        let variable = instanceUnderTest.variables[0]
        AssertSourceDetailsEquals(
            getSourceLocation(for: variable, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 16, 66),
            source: "@available(*, unavailable, message: \"my message\")\nvar name: String"
        )
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String"))
        let attributes = variable.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertAttributesArgumentsEqual(attributes, attributeExpectations)
    }

    func test_variable_withModifiers_willResolveExpectedValues() {
        let source = #"""
        public static var name: String = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)
        // Main
        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String"))
        XCTAssertEqual(variable.modifiers.map(\.name), ["public", "static"])
        AssertSourceDetailsEquals(
            getSourceLocation(for: variable, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 39, 39),
            source: "public static var name: String = \"name\""
        )
    }

    func test_variable_accessors_standard_withBody_willResolveExpectedValues() {
        let source = #"""
        var name: String {
            get { "name" }
            set {}
        }
        var name: String {
            get { "name" }
        }
        var name: String = "name"
        let name: String = "name"
        private(set) var name: String = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 5)

        XCTAssertEqual(instanceUnderTest.variables[0].accessors.map(\.kind), [.get, .set])
        XCTAssertEqual(instanceUnderTest.variables[1].accessors.map(\.kind), [.get])
        XCTAssertEqual(instanceUnderTest.variables[2].accessors.map(\.kind), [])
        XCTAssertEqual(instanceUnderTest.variables[3].accessors.map(\.kind), [])
        XCTAssertEqual(instanceUnderTest.variables[4].accessors.map(\.kind), [])
    }

    func test_variable_accessors_protocol_willResolveExpectedValues() {
        let source = #"""
        protocol MyProtocol {
            var name: String { get set }
            var name: String { get }
            var name: String // Invalid but testing partial/invalids
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)
        XCTAssertEqual(instanceUnderTest.protocols[0].variables.count, 3)

        let protocolOne = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolOne.variables[0].accessors.map(\.kind), [.get, .set])
        XCTAssertEqual(protocolOne.variables[1].accessors.map(\.kind), [.get])
        XCTAssertEqual(protocolOne.variables[2].accessors.map(\.kind), [])
    }

    func test_variable_hasSetterHelper_nested_willResolveExpectedValues() {
        let source = #"""
        protocol Example {
            var name: String { get }
            var name: String { get set }
        }

        class Example {
            let name: String = "test"
            var nameTwo: String = "test"
            var nameThree: String = "test" {
                didSet {}
            }
        }

        struct Example {
            let name: String = "test"
            var nameTwo: String = "test"
            var nameThree: String = "test" {
                didSet {}
            }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        // Protocols
        var variables = instanceUnderTest.protocols[0].variables
        XCTAssertEqual(variables.count, 2)
        XCTAssertFalse(variables[0].hasSetter)
        XCTAssertTrue(variables[1].hasSetter)
        // Class
        variables = instanceUnderTest.classes[0].variables
        XCTAssertEqual(variables.count, 3)
        XCTAssertFalse(variables[0].hasSetter)
        XCTAssertTrue(variables[1].hasSetter)
        XCTAssertTrue(variables[2].hasSetter)
        // Struct
        variables = instanceUnderTest.structures[0].variables
        XCTAssertEqual(variables.count, 3)
        XCTAssertFalse(variables[0].hasSetter)
        XCTAssertTrue(variables[1].hasSetter)
        XCTAssertTrue(variables[2].hasSetter)
    }

    func test_variable_hasSetterHelper_willResolveExpectedValues() {
        let source = #"""
        var name: String {
            get { "name" }
            set {}
        }
        var name: String {
            willSet { }
        }
        var name: String = "name"
        let name: String = "name"
        private(set) var name: String = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 5)
        XCTAssertTrue(instanceUnderTest.variables[0].hasSetter)
        XCTAssertTrue(instanceUnderTest.variables[1].hasSetter)
        XCTAssertTrue(instanceUnderTest.variables[2].hasSetter)
        XCTAssertFalse(instanceUnderTest.variables[3].hasSetter)
        XCTAssertFalse(instanceUnderTest.variables[4].hasSetter)
    }

    func test_variable_simpleType_optionalVariants_willResolveExpectedValues() {
        let source = #"""
        var name: String = "name"
        var name: String? = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        var variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String"))
        XCTAssertFalse(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "\"name\"")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var name: String = \"name\"")
        variable = instanceUnderTest.variables[1]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "name")
        XCTAssertEqual(variable.type, .simple("String?"))
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "\"name\"")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var name: String? = \"name\"")
    }

    func test_variable_voidType_optionalVariants_willResolveExpectedValues() {
        let source = #"""
        var handler: () = {}
        var handler: ()? = {}
        var handler: Void = {}
        var handler: Void? = {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 4)

        var variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertEqual(variable.type, .void("()", false))
        XCTAssertFalse(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{}")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: () = {}")
        variable = instanceUnderTest.variables[1]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertEqual(variable.type, .void("()?", true))
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{}")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: ()? = {}")
        variable = instanceUnderTest.variables[2]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertEqual(variable.type, .void("Void", false))
        XCTAssertFalse(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{}")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: Void = {}")
        variable = instanceUnderTest.variables[3]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertEqual(variable.type, .void("Void?", true))
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{}")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: Void? = {}")
    }

    func test_variable_tupleType_optionalVariants_willResolveExpectedValues() {
        let source = #"""
        var person: (name: String, age: Int?) = ("name", 20)
        var person: (name: String, age: Int?)? = ("name", 20)
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        var variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "person")
        XCTAssertFalse(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "(\"name\", 20)")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var person: (name: String, age: Int?) = (\"name\", 20)")
        if case let EntityType.tuple(tuple) = variable.type {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].name, "name")
            XCTAssertEqual(tuple.elements[0].type, .simple("String"))
            XCTAssertEqual(tuple.elements[1].name, "age")
            XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
            XCTAssertFalse(tuple.isOptional)
            XCTAssertEqual(tuple.description, "(name: String, age: Int?)")
        } else {
            XCTFail("variable type should be tuple")
        }

        variable = instanceUnderTest.variables[1]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "person")
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "(\"name\", 20)")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var person: (name: String, age: Int?)? = (\"name\", 20)")
        if case let EntityType.tuple(tuple) = variable.type {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].name, "name")
            XCTAssertEqual(tuple.elements[0].type, .simple("String"))
            XCTAssertEqual(tuple.elements[1].name, "age")
            XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
            XCTAssertTrue(tuple.isOptional)
            XCTAssertEqual(tuple.description, "(name: String, age: Int?)?")
        } else {
            XCTFail("variable type should be tuple")
        }
    }

    func test_variable_closureType_optionalVariants_willResolveExpectedValues() {
        let source = #"""
        var handler: (String) -> Int? = { _ in }
        var handler: ((String) -> Int?)? = { _ in }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        var variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertFalse(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{ _ in }")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: (String) -> Int? = { _ in }")
        if case let EntityType.closure(closure) = variable.type {
            XCTAssertEqual(closure.input, .simple("String"))
            XCTAssertEqual(closure.output, .simple("Int?"))
            XCTAssertFalse(closure.isOptional)
            XCTAssertEqual(closure.description, "(String) -> Int?")
        } else {
            XCTFail("variable type should be closure")
        }

        variable = instanceUnderTest.variables[1]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertTrue(variable.isOptional)
        XCTAssertEqual(variable.initializedValue, "{ _ in }")
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.description, "var handler: ((String) -> Int?)? = { _ in }")
        if case let EntityType.closure(closure) = variable.type {
            XCTAssertEqual(closure.input, .simple("String"))
            XCTAssertEqual(closure.output, .simple("Int?"))
            XCTAssertTrue(closure.isOptional)
            XCTAssertEqual(closure.description, "((String) -> Int?)?")
        } else {
            XCTFail("variable type should be closure")
        }
    }

    func test_variable_emptyType_partials_willResolveExpectedValues() {
        let source = #"""
        var handler:
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.keyword, "var")
        XCTAssertEqual(variable.name, "handler")
        XCTAssertFalse(variable.isOptional)
        XCTAssertNil(variable.initializedValue)
        XCTAssertTrue(variable.hasSetter)
        XCTAssertEqual(variable.type, .empty)
    }

    func test_variable_accessors_standard_willResolveExpectedValues() throws {
        let source = #"""
        var name: String {
            get {
                "name"
                print("boop")
            }
            set {
                print("hello")
                self.name = newValue
            }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.accessors.count, 2)
        XCTAssertTrue(variable.hasSetter)
        // Get
        XCTAssertEqual(variable.accessors[0].kind, .get)
        let getterBody = try XCTUnwrap(variable.accessors[0].body)
        XCTAssertEqual(getterBody.statements.count, 2)
        XCTAssertEqual(getterBody.statements[0].kind, .init(getterBody.statements[0].node.item))
        XCTAssertEqual(getterBody.statements[0].description, "\"name\"")
        XCTAssertEqual(getterBody.statements[1].kind, .init(getterBody.statements[1].node.item))
        XCTAssertEqual(getterBody.statements[1].description, "print(\"boop\")")
        // Set
        XCTAssertEqual(variable.accessors[1].kind, .set)
        let setterBody = try XCTUnwrap(variable.accessors[1].body)
        XCTAssertEqual(setterBody.statements.count, 2)
        XCTAssertEqual(setterBody.statements[0].kind, .init(setterBody.statements[0].node.item))
        XCTAssertEqual(setterBody.statements[0].description, "print(\"hello\")")
        XCTAssertEqual(setterBody.statements[1].kind, .init(setterBody.statements[1].node.item))
        XCTAssertEqual(setterBody.statements[1].description, "self.name = newValue")
    }

    func test_variable_accessors_effects_throws_willResolveExpectedValues() throws {
        let source = #"""
        var name: String {
            get throws {
                "name"
                print("boop")
            }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.accessors.count, 1)
        XCTAssertFalse(variable.hasSetter)
        // Get
        XCTAssertEqual(variable.accessors[0].kind, .get)
        XCTAssertEqual(variable.accessors[0].effectSpecifiers?.throwsSpecifier, "throws")
        XCTAssertNil(variable.accessors[0].effectSpecifiers?.asyncSpecifier)
    }

    func test_variable_accessors_effects_async_willResolveExpectedValues() throws {
        let source = #"""
        var name: String {
            get async {
                "name"
                print("boop")
            }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.accessors.count, 1)
        XCTAssertFalse(variable.hasSetter)
        // Get
        XCTAssertEqual(variable.accessors[0].kind, .get)
        XCTAssertNil(variable.accessors[0].effectSpecifiers?.throwsSpecifier)
        XCTAssertEqual(variable.accessors[0].effectSpecifiers?.asyncSpecifier, "async")
    }

    func test_variable_accessors_effects_multiple_willResolveExpectedValues() throws {
        let source = #"""
        var name: String {
            get async throws {
                "name"
                print("boop")
            }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let variable = instanceUnderTest.variables[0]
        XCTAssertEqual(variable.accessors.count, 1)
        XCTAssertFalse(variable.hasSetter)
        // Get
        XCTAssertEqual(variable.accessors[0].kind, .get)
        XCTAssertEqual(variable.accessors[0].effectSpecifiers?.throwsSpecifier, "throws")
        XCTAssertEqual(variable.accessors[0].effectSpecifiers?.asyncSpecifier, "async")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        var name: String = "name"
        """#
        let sourceTwo = #"""
        var name: String = "name"
        """#
        let sourceThree = #"""
        var name: String = "name"
        var name: String? = "name"
        var lastName: String? = "name"
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let sampleOne = instanceUnderTest.variables[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        let sampleTwo = instanceUnderTest.variables[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 3)

        let sampleThree = instanceUnderTest.variables[0]
        let sampleFour = instanceUnderTest.variables[1]
        let otherSample = instanceUnderTest.variables[2]

        let equalCases: [(Variable, Variable)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Variable, Variable)] = [
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
