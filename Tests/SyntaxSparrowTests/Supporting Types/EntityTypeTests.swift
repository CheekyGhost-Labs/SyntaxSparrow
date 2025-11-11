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

    // MARK: - Tests: Existential + Opaques: Simple Types

    func test_existentialAndOpaque_asVariable_willReturnExpectedTypes() throws {
        let source = """
            var existentialProtocol: any Sendable
            var opaqueProtocol: some View
            var existentialOptional: (any UIViewController)?
            var opaqueOptional: (some View)?
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 4)

        // var existentialProtocol: any Sendable
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialProtocol")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.existential(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("Sendable"))
        } else {
            XCTFail("variable type should be existential")
        }

        // var opaqueProtocol: some View
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueProtocol")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.opaque(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("View"))
        } else {
            XCTFail("variable type should be opaque")
        }

        // var existentialOptional: (any UIViewController)?
        target = instanceUnderTest.variables[2]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialOptional")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.existential(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("UIViewController"))
        } else {
            XCTFail("variable type should be existential")
        }

        // var opaqueOptional: (some View)?
        target = instanceUnderTest.variables[3]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueOptional")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.opaque(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("View"))
        } else {
            XCTFail("variable type should be opaque")
        }
    }

    func test_existentialAndOpaque_withProtocolComposition_willReturnExpectedTypes() throws {
        let source = """
            var existentialComposed: any Sendable & Codable
            var opaqueComposed: some Sendable & Codable
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 2)

        // var existentialComposed: any Sendable & Codable
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialComposed")

        if case let EntityType.existential(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("Sendable & Codable"))
        } else {
            XCTFail("variable type should be existential")
        }

        // var opaqueComposed: some Sendable & Codable
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueComposed")

        if case let EntityType.opaque(innerType) = target.type {
            XCTAssertEqual(innerType, .simple("Sendable & Codable"))
        } else {
            XCTFail("variable type should be opaque")
        }
    }

    // MARK: - Tests: Existential + Opaques: Arrays

    func test_existentialAndOpaque_inArray_willReturnExpectedTypes() throws {
        let source = """
            var existentialArray: [any Codable]
            var opaqueArray: [some View]
            var existentialArrayOptional: [any Sendable]?
            var opaqueArrayOptional: [some View]?
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 4)

        // var existentialArray: [any Codable]
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialArray")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertFalse(array.isOptional)
            if case let EntityType.existential(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("Codable"))
            } else {
                XCTFail("array element type should be existential")
            }
        } else {
            XCTFail("variable type should be array")
        }

        // var opaqueArray: [some View]
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueArray")
        XCTAssertFalse(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertFalse(array.isOptional)
            if case let EntityType.opaque(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("array element type should be opaque")
            }
        } else {
            XCTFail("variable type should be array")
        }

        // var existentialArrayOptional: [any Sendable]?
        target = instanceUnderTest.variables[2]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialArrayOptional")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertTrue(array.isOptional)
            if case let EntityType.existential(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("Sendable"))
            } else {
                XCTFail("array element type should be existential")
            }
        } else {
            XCTFail("variable type should be array")
        }

        // var opaqueArrayOptional: [some View]?
        target = instanceUnderTest.variables[3]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueArrayOptional")
        XCTAssertTrue(target.isOptional)

        if case let EntityType.array(array) = target.type {
            XCTAssertTrue(array.isOptional)
            if case let EntityType.opaque(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("array element type should be opaque")
            }
        } else {
            XCTFail("variable type should be array")
        }
    }

    // MARK: - Tests: Existential + Opaques: Dictionaries

    func test_existentialAndOpaque_inDictionary_willReturnExpectedTypes() throws {
        let source = """
            var existentialDict: [String: any Codable]
            var opaqueDict: [String: some View]
            var mixedDict: [any Hashable: some View]
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 3)

        // var existentialDict: [String: any Codable]
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialDict")

        if case let EntityType.dictionary(dict) = target.type {
            XCTAssertFalse(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.existential(innerType) = dict.valueType {
                XCTAssertEqual(innerType, .simple("Codable"))
            } else {
                XCTFail("dictionary value type should be existential")
            }
        } else {
            XCTFail("variable type should be dictionary")
        }

        // var opaqueDict: [String: some View]
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueDict")

        if case let EntityType.dictionary(dict) = target.type {
            XCTAssertFalse(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            if case let EntityType.opaque(innerType) = dict.valueType {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("dictionary value type should be opaque")
            }
        } else {
            XCTFail("variable type should be dictionary")
        }

        // var mixedDict: [any Hashable: some View]
        target = instanceUnderTest.variables[2]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "mixedDict")

        if case let EntityType.dictionary(dict) = target.type {
            XCTAssertFalse(dict.isOptional)
            if case let EntityType.existential(keyType) = dict.keyType {
                XCTAssertEqual(keyType, .simple("Hashable"))
            } else {
                XCTFail("dictionary key type should be existential")
            }
            if case let EntityType.opaque(valueType) = dict.valueType {
                XCTAssertEqual(valueType, .simple("View"))
            } else {
                XCTFail("dictionary value type should be opaque")
            }
        } else {
            XCTFail("variable type should be dictionary")
        }
    }

    // MARK: - Tests: Existential + Opaques: Closures

    func test_existentialAndOpaque_inClosure_willReturnExpectedTypes() throws {
        let source = """
            var existentialHandler: (any Sendable) -> Void
            var opaqueHandler: (some Sendable) -> Void
            var existentialFactory: () -> any View
            var opaqueFactory: () -> some View
            var mixedTransformer: (any Codable) -> some View
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 5)

        // var existentialHandler: (any Sendable) -> Void
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialHandler")

        if case let EntityType.closure(closure) = target.type {
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                XCTAssertEqual(tuple.elements[0].type, .existential(.simple("Sendable")))
            } else {
                XCTFail("closure input type should be existential")
            }
            XCTAssertEqual(closure.output, .void("Void", false))
        } else {
            XCTFail("variable type should be closure")
        }

        // var opaqueHandler: (some Sendable) -> Void
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueHandler")

        if case let EntityType.closure(closure) = target.type {
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                XCTAssertEqual(tuple.elements[0].type, .opaque(.simple("Sendable")))
            } else {
                XCTFail("closure input type should be opaque")
            }
            XCTAssertEqual(closure.output, .void("Void", false))
        } else {
            XCTFail("variable type should be closure")
        }

        // var existentialFactory: () -> any View
        target = instanceUnderTest.variables[2]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialFactory")

        if case let EntityType.closure(closure) = target.type {
            if case let EntityType.existential(innerType) = closure.output {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("closure output type should be existential")
            }
        } else {
            XCTFail("variable type should be closure")
        }

        // var opaqueFactory: () -> some View
        target = instanceUnderTest.variables[3]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueFactory")

        if case let EntityType.closure(closure) = target.type {
            if case let EntityType.opaque(innerType) = closure.output {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("closure output type should be opaque")
            }
        } else {
            XCTFail("variable type should be closure")
        }

        // var mixedTransformer: (any Codable) -> some View
        target = instanceUnderTest.variables[4]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "mixedTransformer")

        if case let EntityType.closure(closure) = target.type {
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                XCTAssertEqual(tuple.elements[0].type, .existential(.simple("Codable")))
            } else {
                XCTFail("closure input type should be existential")
            }
            if case let EntityType.opaque(outputType) = closure.output {
                XCTAssertEqual(outputType, .simple("View"))
            } else {
                XCTFail("closure output type should be opaque")
            }
        } else {
            XCTFail("variable type should be closure")
        }
    }

    // MARK: - Tests: Existential + Opaques: Tuples

    func test_existentialAndOpaque_inTuple_willReturnExpectedTypes() throws {
        let source = """
            var existentialTuple: (any Codable, String)
            var opaqueTuple: (some View, Int)
            var mixedTuple: (any Codable, some View)
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 3)

        // var existentialTuple: (any Codable, String)
        var target = instanceUnderTest.variables[0]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "existentialTuple")

        if case let EntityType.tuple(tuple) = target.type {
            XCTAssertEqual(tuple.elements.count, 2)
            if case let EntityType.existential(firstType) = tuple.elements[0].type {
                XCTAssertEqual(firstType, .simple("Codable"))
            } else {
                XCTFail("first tuple element should be existential")
            }
            XCTAssertEqual(tuple.elements[1].type, .simple("String"))
        } else {
            XCTFail("variable type should be tuple")
        }

        // var opaqueTuple: (some View, Int)
        target = instanceUnderTest.variables[1]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "opaqueTuple")

        if case let EntityType.tuple(tuple) = target.type {
            XCTAssertEqual(tuple.elements.count, 2)
            if case let EntityType.opaque(firstType) = tuple.elements[0].type {
                XCTAssertEqual(firstType, .simple("View"))
            } else {
                XCTFail("first tuple element should be opaque")
            }
            XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
        } else {
            XCTFail("variable type should be tuple")
        }

        // var mixedTuple: (any Codable, some View)
        target = instanceUnderTest.variables[2]
        XCTAssertEqual(target.keyword, "var")
        XCTAssertEqual(target.name, "mixedTuple")

        if case let EntityType.tuple(tuple) = target.type {
            XCTAssertEqual(tuple.elements.count, 2)
            if case let EntityType.existential(firstType) = tuple.elements[0].type {
                XCTAssertEqual(firstType, .simple("Codable"))
            } else {
                XCTFail("first tuple element should be existential")
            }
            if case let EntityType.opaque(secondType) = tuple.elements[1].type {
                XCTAssertEqual(secondType, .simple("View"))
            } else {
                XCTFail("second tuple element should be opaque")
            }
        } else {
            XCTFail("variable type should be tuple")
        }
    }

    // MARK: - Tests: Existential + Opaques: Type Aliases

    func test_existentialAndOpaque_asTypeAlias_willReturnExpectedTypes() throws {
        let source = """
            typealias ExistentialType = any Sendable
            typealias OpaqueType = some View
            typealias ExistentialArray = [any Codable]
            typealias OpaqueArray = [some View]
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 4)

        // typealias ExistentialType = any Sendable
        var target = instanceUnderTest.typealiases[0]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "ExistentialType")

        if case let EntityType.existential(innerType) = target.initializedType {
            XCTAssertEqual(innerType, .simple("Sendable"))
        } else {
            XCTFail("typealias type should be existential")
        }

        // typealias OpaqueType = some View
        target = instanceUnderTest.typealiases[1]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "OpaqueType")

        if case let EntityType.opaque(innerType) = target.initializedType {
            XCTAssertEqual(innerType, .simple("View"))
        } else {
            XCTFail("typealias type should be opaque")
        }

        // typealias ExistentialArray = [any Codable]
        target = instanceUnderTest.typealiases[2]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "ExistentialArray")

        if case let EntityType.array(array) = target.initializedType {
            if case let EntityType.existential(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("Codable"))
            } else {
                XCTFail("array element type should be existential")
            }
        } else {
            XCTFail("typealias type should be array")
        }

        // typealias OpaqueArray = [some View]
        target = instanceUnderTest.typealiases[3]
        XCTAssertEqual(target.keyword, "typealias")
        XCTAssertEqual(target.name, "OpaqueArray")

        if case let EntityType.array(array) = target.initializedType {
            if case let EntityType.opaque(innerType) = array.elementType {
                XCTAssertEqual(innerType, .simple("View"))
            } else {
                XCTFail("array element type should be opaque")
            }
        } else {
            XCTFail("typealias type should be array")
        }
    }

    // MARK: - Tests: Existential + Opaques: Function Parameters

    func test_existentialAndOpaque_inFunctionParameter_willReturnExpectedTypes() throws {
        let source = """
            func handleExistential(value: any Sendable) {}
            func handleOpaque(value: some Sendable) {}
            func handleMixed(input: any Codable, output: some View) {}
            """
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 3)

        // func handleExistential(value: any Sendable) {}
        var function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "handleExistential")
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.existential(innerType) = function.signature.input[0].type {
            XCTAssertEqual(innerType, .simple("Sendable"))
        } else {
            XCTFail("parameter type should be existential")
        }

        // func handleOpaque(value: some Sendable) {}
        function = instanceUnderTest.functions[1]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "handleOpaque")
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.opaque(innerType) = function.signature.input[0].type {
            XCTAssertEqual(innerType, .simple("Sendable"))
        } else {
            XCTFail("parameter type should be opaque")
        }

        // func handleMixed(input: any Codable, output: some View) {}
        function = instanceUnderTest.functions[2]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "handleMixed")
        XCTAssertEqual(function.signature.input.count, 2)

        if case let EntityType.existential(firstType) = function.signature.input[0].type {
            XCTAssertEqual(firstType, .simple("Codable"))
        } else {
            XCTFail("first parameter type should be existential")
        }

        if case let EntityType.opaque(secondType) = function.signature.input[1].type {
            XCTAssertEqual(secondType, .simple("View"))
        } else {
            XCTFail("second parameter type should be opaque")
        }
    }
}
