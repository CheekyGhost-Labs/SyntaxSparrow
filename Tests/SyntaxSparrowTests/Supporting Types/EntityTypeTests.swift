//
//  EntityTypeTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class EntityTypeTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Tests: Array

    func test_array_inFunctionParameter_willReturnExpectedTypes() throws {
        let source = """
        func arrayShorthand(persons: [(name: String, age: Int?)]?) {}
        func arrayIdentifier(names: Array<String>) {}
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 2)

        var function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "arrayShorthand")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.array(array) = function.signature.input[0].type {
            XCTAssertEqual(array.declType, .squareBrackets)
            XCTAssertTrue(array.isOptional)
            if case let EntityType.tuple(tuple) = array.elementType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        // func arrayIdentifier(names: Array<String>) {}
        function = instanceUnderTest.functions[1]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "arrayIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.array(array) = function.signature.input[0].type {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String"))
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }
    }

    func test_array_asVariable_willReturnExpectedTypes() throws {
        let source = """
        var arrayShorthand: [(name: String, age: Int?)]?
        var arrayIdentifier: Array<String>)
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        // var arrayShorthand: [(name: String, age: Int?)]?
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "arrayShorthand")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertEqual(array.declType, .squareBrackets)
            XCTAssertTrue(array.isOptional)
            if case let EntityType.tuple(tuple) = array.elementType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Array")
        }

        // var arrayIdentifier: Array<String>)
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "arrayIdentifier")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String"))
        } else {
            XCTFail("variable type should be Array")
        }
    }

    func test_array_asTypeAlias_willReturnExpectedTypes() throws {
        let source = """
        typealias ArrayShorthand = [(name: String, age: Int?)]?
        typealias ArrayIdentifier = Array<String>
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 2)

        // typealias ArrayShorthand = [(name: String, age: Int?)]?
        var target = instanceUnderTest.typealiases[0]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "ArrayShorthand")

        if case let EntityType.array(array) = target.initializedType {
            XCTAssertEqual(array.declType, .squareBrackets)
            XCTAssertTrue(array.isOptional)
            if case let EntityType.tuple(tuple) = array.elementType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Array")
        }

        // typealias ArrayIdentifier = Array<String>)
        target = instanceUnderTest.typealiases[1]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "ArrayIdentifier")

        if case let EntityType.array(array) = target.initializedType {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String"))
        } else {
            XCTFail("variable type should be Array")
        }
    }

    // MARK: - Tests: Set

    func test_set_inFunctionParameter_willReturnExpectedTypes() throws {
        let source = """
        func setIdentifier(names: Set<(name: String, age: Int?)>) {}
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        // func setIdentifier(names: Set<(name: String, age: Int?)>) {}
        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "setIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.set(set) = function.signature.input[0].type {
            XCTAssertFalse(set.isOptional)
            if case let EntityType.tuple(tuple) = set.elementType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Array")
        }
    }

    func test_set_asVariable_willReturnExpectedTypes() throws {
        let source = """
        var setIdentifier: Set<(name: String, age: Int?)>
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 1)

        // var setIdentifier: Array<(name: String, age: Int?)>
        let target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "setIdentifier")

        if case let EntityType.set(set) = target.type {
            XCTAssertFalse(set.isOptional)
            if case let EntityType.tuple(tuple) = set.elementType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Set")
        }
    }

    func test_set_asTypeAlias_willReturnExpectedTypes() throws {
        let source = """
        typealias SetIdentifier = Set<String>
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        // typealias SetIdentifier = Set<String>
        let target = instanceUnderTest.typealiases[0]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "SetIdentifier")

        if case let EntityType.set(set) = target.initializedType {
            XCTAssertFalse(set.isOptional)
            XCTAssertEqual(set.elementType, .simple("String"))
        } else {
            XCTFail("variable type should be Array")
        }
    }

    // MARK: - Tests: Dictionary

    func test_dictionary_inFunctionParameter_willReturnExpectedTypes() throws {
        let source = """
        func dictShorthand(persons: [String: (name: String, age: Int?)]?) {}
        func dictIdentifier(names: Dictionary<String, (name: String, age: Int?)>) {}
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 2)

        // func dictShorthand(persons: [String: (name: String, age: Int?)]?) {}

        var function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "dictShorthand")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.dictionary(dict) = function.signature.input[0].type {
            XCTAssertEqual(dict.declType, .squareBrackets)
            XCTAssertTrue(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("function.signature.input[0] type should be Dictionary")
        }

        // func dictIdentifier(names: Dictionary<String, (name: String, age: Int?)>) {}
        function = instanceUnderTest.functions[1]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "dictIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.dictionary(dict) = function.signature.input[0].type {
            XCTAssertEqual(dict.declType, .generics)
            XCTAssertFalse(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("function.signature.input[0] type should be Dictionary")
        }
    }

    func test_dictionary_asVariable_willReturnExpectedTypes() throws {
        let source = """
        var dictShorthand: [String: (name: String, age: Int?)]?
        var dictIdentifier: Dictionary<String, (name: String, age: Int?)>)
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        // var dictShorthand: [String: (name: String, age: Int?)]?
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "dictShorthand")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.dictionary(dict) = target.type {
            XCTAssertEqual(dict.declType, .squareBrackets)
            XCTAssertTrue(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Dictionary")
        }

        // var dictIdentifier: Dictionary<String, (name: String, age: Int?)>)
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "dictIdentifier")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.dictionary(dict) = target.type {
            XCTAssertEqual(dict.declType, .generics)
            XCTAssertFalse(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Array")
        }
    }

    func test_dictionary_asTypeAlias_willReturnExpectedTypes() throws {
        let source = """
        typealias DictShorthand = [String: (name: String, age: Int?)]?
        typealias DictIdentifier = Dictionary<String, (name: String, age: Int?)>
        """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 2)

        // typealias DictShorthand = [String: (name: String, age: Int?)]?
        var target = instanceUnderTest.typealiases[0]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "DictShorthand")

        if case let EntityType.dictionary(dict) = target.initializedType {
            XCTAssertEqual(dict.declType, .squareBrackets)
            XCTAssertTrue(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Dictionary")
        }

        // typealias DictIdentifier = Dictionary<String, (name: String, age: Int?)>
        target = instanceUnderTest.typealiases[1]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "DictIdentifier")

        if case let EntityType.dictionary(dict) = target.initializedType {
            XCTAssertEqual(dict.declType, .generics)
            XCTAssertFalse(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.tuple(tuple) = dict.valueType {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int?"))
                XCTAssertFalse(tuple.isOptional)
            }
        } else {
            XCTFail("variable type should be Array")
        }
    }
}
