//
//  FunctionTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class FunctionTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_function_withAttributesAndModifiers() throws {
        let source = #"""
        @available(iOS 15, *)
        static public func executeOrder66() throws {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let function = instanceUnderTest.functions[0]

        XCTAssertEqual(function.modifiers.count, 2)
        XCTAssertEqual(function.modifiers.map(\.name), ["static", "public"])
        XCTAssertEqual(function.attributes.count, 1)
        XCTAssertEqual(function.attributes[0].name, "available")
        XCTAssertEqual(function.attributes[0].arguments.count, 2)
        XCTAssertNil(function.attributes[0].arguments[0].name)
        XCTAssertEqual(function.attributes[0].arguments[0].value, "iOS 15")
        XCTAssertNil(function.attributes[0].arguments[1].name)
        XCTAssertEqual(function.attributes[0].arguments[1].value, "*")
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "executeOrder66")
        XCTAssertEqual(function.signature.throwsOrRethrowsKeyword, "throws")
        XCTAssertSourceStartPositionEquals(function.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(function.sourceLocation, (1, 45, 67))
        XCTAssertEqual(
            function.extractFromSource(source),
            "@available(iOS 15, *)\nstatic public func executeOrder66() throws {}"
        )
    }

    func test_function_withChildDeclarations_willResolveExpectedChildDeclarations() throws {
        let source = #"""
        func executeOrder66() {
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
        XCTAssertEqual(instanceUnderTest.functions.count, 1)
        // A
        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.identifier, "executeOrder66")
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.modifiers.count, 0)
        XCTAssertEqual(function.attributes.count, 0)
        XCTAssertSourceStartPositionEquals(function.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(function.sourceLocation, (12, 1, 418))
        XCTAssertEqual(function.extractFromSource(source), source)
        // Children
        XCTAssertEqual(function.structures.count, 1)
        XCTAssertEqual(function.structures[0].name, "NestedStruct")
        XCTAssertEqual(function.classes.count, 1)
        XCTAssertEqual(function.classes[0].name, "NestedClass")
        XCTAssertEqual(function.enumerations.count, 1)
        XCTAssertEqual(function.enumerations[0].name, "NestedEnum")
        XCTAssertEqual(function.typealiases.count, 1)
        XCTAssertEqual(function.typealiases[0].name, "NestedTypeAlias")
        XCTAssertEqual(function.functions.count, 1)
        XCTAssertEqual(function.functions[0].identifier, "nestedFunction")
        XCTAssertEqual(function.variables.count, 1)
        XCTAssertEqual(function.variables[0].name, "nestedVariable")
        XCTAssertEqual(function.protocols.count, 1)
        XCTAssertEqual(function.protocols[0].name, "NestedProtocol")
        XCTAssertEqual(function.subscripts.count, 1)
        XCTAssertEqual(function.subscripts[0].keyword, "subscript")
        XCTAssertEqual(function.initializers.count, 1)
        XCTAssertEqual(function.initializers[0].keyword, "init")
        XCTAssertEqual(function.deinitializers.count, 1)
        XCTAssertEqual(function.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(function.operators.count, 1)
        XCTAssertEqual(function.operators[0].name, "+-")
    }

    func test_function_operators_willResolveExptectedTypes() throws {
        let source = #"""
        prefix func ¬(value: Bool) -> Bool? { !value }
        func ±(lhs: Int?, rhs: Int) -> (Int, Int) { (lhs + rhs, lhs - rhs) }
        postfix func °(value: Double) -> String { "\(value)°)" }
        extension Int {
            static func ∓(lhs: Int, rhs: Int) -> (Int, Int) { (lhs - rhs, lhs + rhs) }
        }
        func sayHello() { print("Hello") }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 4)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)
        XCTAssertEqual(instanceUnderTest.extensions[0].functions.count, 1)

        let prefix = instanceUnderTest.functions[0]
        XCTAssertEqual(prefix.modifiers.count, 1)
        XCTAssertEqual(prefix.modifiers[0].name, "prefix")
        XCTAssertEqual(prefix.identifier, "¬")
        XCTAssertTrue(prefix.isOperator)
        XCTAssertEqual(prefix.operatorKind, .prefix)
        XCTAssertEqual(prefix.signature.output, .simple("Bool?"))
        XCTAssertEqual(prefix.signature.input.count, 1)
        XCTAssertEqual(prefix.signature.input[0].name, "value")
        XCTAssertNil(prefix.signature.input[0].secondName)
        XCTAssertEqual(prefix.signature.input[0].type, .simple("Bool"))

        let infix = instanceUnderTest.functions[1]
        XCTAssertTrue(infix.modifiers.isEmpty)
        XCTAssertEqual(infix.identifier, "±")
        XCTAssertTrue(infix.isOperator)
        XCTAssertEqual(infix.operatorKind, .infix)
        XCTAssertEqual(infix.signature.input.count, 2)
        XCTAssertEqual(infix.signature.input[0].name, "lhs")
        XCTAssertNil(infix.signature.input[0].secondName)
        XCTAssertEqual(infix.signature.input[0].type, .simple("Int?"))
        XCTAssertEqual(infix.signature.input[1].name, "rhs")
        XCTAssertNil(infix.signature.input[1].secondName)
        XCTAssertEqual(infix.signature.input[1].type, .simple("Int"))
        // High level entity type check
        let infixOutput = try XCTUnwrap(infix.signature.output)
        if case let EntityType.tuple(tuple) = infixOutput {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
            XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
        } else {
            XCTFail("infix function should return a tuple")
        }

        let postfix = instanceUnderTest.functions[2]
        XCTAssertEqual(postfix.modifiers.count, 1)
        XCTAssertEqual(postfix.modifiers[0].name, "postfix")
        XCTAssertEqual(postfix.identifier, "°")
        XCTAssertTrue(postfix.isOperator)
        XCTAssertEqual(postfix.operatorKind, .postfix)
        XCTAssertEqual(postfix.signature.input.count, 1)
        XCTAssertEqual(postfix.signature.input[0].name, "value")
        XCTAssertNil(postfix.signature.input[0].secondName)
        XCTAssertEqual(postfix.signature.input[0].type, .simple("Double"))
        XCTAssertEqual(postfix.signature.output, .simple("String"))

        let staticInfix = instanceUnderTest.extensions[0].functions[0]
        XCTAssertEqual(staticInfix.modifiers.count, 1)
        XCTAssertEqual(staticInfix.modifiers[0].name, "static")
        XCTAssertEqual(staticInfix.identifier, "∓")
        XCTAssertTrue(staticInfix.isOperator)
        XCTAssertEqual(staticInfix.operatorKind, .infix)
        XCTAssertEqual(staticInfix.signature.input[0].name, "lhs")
        XCTAssertNil(staticInfix.signature.input[0].secondName)
        XCTAssertEqual(staticInfix.signature.input[0].type, .simple("Int"))
        XCTAssertEqual(staticInfix.signature.input[1].name, "rhs")
        XCTAssertNil(staticInfix.signature.input[1].secondName)
        XCTAssertEqual(staticInfix.signature.input[1].type, .simple("Int"))
        // High level entity type check
        let staticInfixOutput = try XCTUnwrap(staticInfix.signature.output)
        if case let EntityType.tuple(tuple) = staticInfixOutput {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
            XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
        } else {
            XCTFail("static infix function should return a tuple")
        }

        // Not operator
        let nonoperator = instanceUnderTest.functions[3]
        XCTAssert(nonoperator.modifiers.isEmpty)
        XCTAssertEqual(nonoperator.identifier, "sayHello")
        XCTAssertFalse(nonoperator.isOperator)
        XCTAssertNil(nonoperator.operatorKind)
    }

    func test_functions_withGenericParametersAndRequirements_willResolveExpectedValues() throws {
        let source = #"""
        func executeOrder66<T: Equatable>(withValue value: T) where T: Hashable {}
        func executeOrder66<C1: Collection, C2: Collection>(between lhs: C1, and rhs: C2) -> [C1.Element]
            where C1.Element: Equatable, C1.Element == C2.Element { ... }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 2)

        var function = instanceUnderTest.functions[0]

        // Function One
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].name, "withValue")
        XCTAssertEqual(function.signature.input[0].secondName, "value")
        XCTAssertEqual(function.signature.input[0].type, .simple("T"))
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertSourceStartPositionEquals(function.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(function.sourceLocation, (0, 74, 74))
        XCTAssertEqual(
            function.extractFromSource(source),
            "func executeOrder66<T: Equatable>(withValue value: T) where T: Hashable {}"
        )
        // Function One: Parameters
        XCTAssertEqual(function.genericParameters.count, 1)
        XCTAssertEqual(function.genericParameters[0].name, "T")
        XCTAssertEqual(function.genericParameters[0].type, "Equatable")
        // Function One: Requirements
        XCTAssertEqual(function.genericRequirements.count, 1)
        XCTAssertEqual(function.genericRequirements[0].relation, .conformance)
        XCTAssertEqual(function.genericRequirements[0].leftTypeIdentifier, "T")
        XCTAssertEqual(function.genericRequirements[0].rightTypeIdentifier, "Hashable")

        function = instanceUnderTest.functions[1]
        // Function Two
        XCTAssertEqual(function.signature.input.count, 2)
        XCTAssertEqual(function.signature.input[0].name, "between")
        XCTAssertEqual(function.signature.input[0].secondName, "lhs")
        XCTAssertEqual(function.signature.input[0].type, .simple("C1"))
        XCTAssertEqual(function.signature.input[1].name, "and")
        XCTAssertEqual(function.signature.input[1].secondName, "rhs")
        XCTAssertEqual(function.signature.input[1].type, .simple("C2"))
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertEqual(function.signature.output, .simple("[C1.Element]"))
        XCTAssertSourceStartPositionEquals(function.sourceLocation, (1, 0, 75))
        XCTAssertSourceEndPositionEquals(function.sourceLocation, (2, 65, 238))
        XCTAssertEqual(
            function.extractFromSource(source),
            "func executeOrder66<C1: Collection, C2: Collection>(between lhs: C1, and rhs: C2) -> [C1.Element]\n    where C1.Element: Equatable, C1.Element == C2.Element { ... }"
        )
        // Function One: Parameters
        XCTAssertEqual(function.genericParameters.count, 2)
        XCTAssertEqual(function.genericParameters[0].name, "C1")
        XCTAssertEqual(function.genericParameters[0].type, "Collection")
        XCTAssertEqual(function.genericParameters[1].name, "C2")
        XCTAssertEqual(function.genericParameters[1].type, "Collection")
        // Function One: Requirements
        XCTAssertEqual(function.genericRequirements.count, 2)
        XCTAssertEqual(function.genericRequirements[0].relation, .conformance)
        XCTAssertEqual(function.genericRequirements[0].leftTypeIdentifier, "C1.Element")
        XCTAssertEqual(function.genericRequirements[0].rightTypeIdentifier, "Equatable")
        XCTAssertEqual(function.genericRequirements[1].relation, .sameType)
        XCTAssertEqual(function.genericRequirements[1].leftTypeIdentifier, "C1.Element")
        XCTAssertEqual(function.genericRequirements[1].rightTypeIdentifier, "C2.Element")
    }

    func test_function_parameters_willResolveExptectedTypes() throws {
        let source = #"""
        func noParameters() throws {}
        func labelOmitted(_ name: String) {}
        func singleName(name: String) {}
        func singleNameOptional(name: String?) {}
        func twoNames(withName name: String) {}
        func optionalSimple(_ name: String?) {}
        func variadic(names: String...) {}
        func variadicOptional(_ names: String?...) {}
        func multipleParameters(name: String, age: Int?) {}
        func throwing(name: String, age: Int?) throws {}
        func tuple(person: (name: String, age: Int?)?) {}
        func closure(_ handler: @escaping (Int) -> Void) {}
        func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
        func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
        func result(processResult: Result<String, Error>) {}
        func resultOptional(processResult: Result<String, Error>?) {}
        func defaultValue(name: String = "name") {}
        func inoutValue(names: inout [String]) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 18)

        // No Parameters
        // func noParameters() throws {}
        var function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "noParameters")
        XCTAssertEqual(function.signature.throwsOrRethrowsKeyword, "throws")
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 0)

        // Label Omitted
        // func labelOmitted(_ name: String) {}
        function = instanceUnderTest.functions[1]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "labelOmitted")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "name")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].description, "_ name: String")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // Single Name
        // func singleName(name: String) {}
        function = instanceUnderTest.functions[2]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "singleName")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "name")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].description, "name: String")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // Single Name Optional
        // func singleNameOptional(name: String?) {}
        function = instanceUnderTest.functions[3]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "singleNameOptional")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "name")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String?"))
        XCTAssertEqual(function.signature.input[0].isOptional, true)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String?")
        XCTAssertEqual(function.signature.input[0].description, "name: String?")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // Two Names
        // func twoNames(withName name: String) {}
        function = instanceUnderTest.functions[4]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "twoNames")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "withName")
        XCTAssertEqual(function.signature.input[0].secondName, "name")
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].description, "withName name: String")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // optionalSimple
        // func optionalSimple(_ name: String?) {}
        function = instanceUnderTest.functions[5]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "optionalSimple")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "name")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String?"))
        XCTAssertEqual(function.signature.input[0].isOptional, true)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String?")
        XCTAssertEqual(function.signature.input[0].description, "_ name: String?")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // variadic
        // func variadic(name: String...) {}
        function = instanceUnderTest.functions[6]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "variadic")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "names")
        XCTAssertEqual(function.signature.input[0].secondName, nil)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertTrue(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String..."))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String...") // see if can get ellipsis
        XCTAssertEqual(function.signature.input[0].description, "names: String...")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // variadic optional
        // func variadicOptional(_ names: String?...) {}
        function = instanceUnderTest.functions[7]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "variadicOptional")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "names")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertTrue(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String?..."))
        XCTAssertEqual(function.signature.input[0].isOptional, true)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String?...") // see if can get ellipsis
        XCTAssertEqual(function.signature.input[0].description, "_ names: String?...")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))

        // multiple parameters
        // func multipleParameters(name: String, age: Int?) {}
        function = instanceUnderTest.functions[8]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "multipleParameters")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 2)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "name")
        XCTAssertEqual(function.signature.input[0].secondName, nil)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].description, "name: String")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))
        XCTAssertEqual(function.signature.input[1].attributes, [])
        XCTAssertEqual(function.signature.input[1].modifiers, [])
        XCTAssertEqual(function.signature.input[1].name, "age")
        XCTAssertEqual(function.signature.input[1].secondName, nil)
        XCTAssertFalse(function.signature.input[1].isLabelOmitted)
        XCTAssertFalse(function.signature.input[1].isVariadic)
        XCTAssertEqual(function.signature.input[1].type, .simple("Int?"))
        XCTAssertEqual(function.signature.input[1].isOptional, true)
        XCTAssertFalse(function.signature.input[1].isInOut)
        XCTAssertEqual(function.signature.input[1].rawType, "Int?")
        XCTAssertEqual(function.signature.input[1].description, "age: Int?")
        XCTAssertNotNil(function.signature.input[1].node.as(FunctionParameterSyntax.self))

        // multiple parameters throwing
        // func throwing(name: String, age: Int?) throws {}
        function = instanceUnderTest.functions[9]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "throwing")
        XCTAssertEqual(function.signature.throwsOrRethrowsKeyword, "throws")
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 2)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "name")
        XCTAssertEqual(function.signature.input[0].secondName, nil)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].isOptional, false)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].description, "name: String")
        XCTAssertNotNil(function.signature.input[0].node.as(FunctionParameterSyntax.self))
        XCTAssertEqual(function.signature.input[1].attributes, [])
        XCTAssertEqual(function.signature.input[1].modifiers, [])
        XCTAssertEqual(function.signature.input[1].name, "age")
        XCTAssertEqual(function.signature.input[1].secondName, nil)
        XCTAssertFalse(function.signature.input[1].isLabelOmitted)
        XCTAssertFalse(function.signature.input[1].isVariadic)
        XCTAssertEqual(function.signature.input[1].type, .simple("Int?"))
        XCTAssertEqual(function.signature.input[1].isOptional, true)
        XCTAssertFalse(function.signature.input[1].isInOut)
        XCTAssertNil(function.signature.input[1].defaultArgument)
        XCTAssertEqual(function.signature.input[1].rawType, "Int?")
        XCTAssertEqual(function.signature.input[1].description, "age: Int?")
        XCTAssertNotNil(function.signature.input[1].node.as(FunctionParameterSyntax.self))

        // tuple parameter
        // func tuple(person: (name: String, age: Int?)?) {}
        function = instanceUnderTest.functions[10]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "tuple")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "person")
        XCTAssertEqual(function.signature.input[0].secondName, nil)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertTrue(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "(name: String, age: Int?)?")
        XCTAssertEqual(function.signature.input[0].description, "person: (name: String, age: Int?)?")

        if case let EntityType.tuple(tuple) = function.signature.input[0].type {
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

        // escaping closure parameter
        // func closure(_ handler: @escaping (Int) -> Void) {}
        function = instanceUnderTest.functions[11]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "closure")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes.map(\.name), ["escaping"])
        XCTAssertEqual(function.signature.input[0].attributes.flatMap(\.arguments), [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "handler")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertFalse(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "@escaping (Int) -> Void")
        XCTAssertEqual(function.signature.input[0].description, "_ handler: @escaping (Int) -> Void")

        if case let EntityType.closure(closure) = function.signature.input[0].type {
            XCTAssertEqual(closure.input, .simple("Int"))
            XCTAssertFalse(closure.isVoidInput)
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertFalse(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertFalse(closure.isAutoEscaping)
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // auto escaping closure parameter
        // func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
        function = instanceUnderTest.functions[12]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "autoEscapingClosure")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "handler")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertTrue(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "((Int) -> Void)?")
        XCTAssertEqual(function.signature.input[0].description, "_ handler: ((Int) -> Void)?")

        if case let EntityType.closure(closure) = function.signature.input[0].type {
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
        // func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
        function = instanceUnderTest.functions[13]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "complexClosure")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "_")
        XCTAssertEqual(function.signature.input[0].secondName, "handler")
        XCTAssertTrue(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertTrue(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "((name: String, age: Int) -> String?)?")
        XCTAssertEqual(function.signature.input[0].description, "_ handler: ((name: String, age: Int) -> String?)?")

        if case let EntityType.closure(closure) = function.signature.input[0].type {
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
        // func result(processResult: Result<String, Error>) {}
        function = instanceUnderTest.functions[14]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "result")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "processResult")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertFalse(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].rawType, "Result<String, Error>")
        XCTAssertEqual(function.signature.input[0].description, "processResult: Result<String, Error>")

        if case let EntityType.result(result) = function.signature.input[0].type {
            XCTAssertEqual(result.successType, .simple("String"))
            XCTAssertEqual(result.failureType, .simple("Error"))
            XCTAssertFalse(result.isOptional)
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // func resultOptional(processResult: Result<String, Error>?) {}
        function = instanceUnderTest.functions[15]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "resultOptional")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "processResult")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertTrue(function.signature.input[0].isOptional)
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "Result<String, Error>?")
        XCTAssertEqual(function.signature.input[0].description, "processResult: Result<String, Error>?")

        if case let EntityType.result(result) = function.signature.input[0].type {
            XCTAssertEqual(result.successType, .simple("String"))
            XCTAssertEqual(result.failureType, .simple("Error"))
            XCTAssertTrue(result.isOptional)
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // func defaultValue(name: String = "name") {}
        function = instanceUnderTest.functions[16]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "defaultValue")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "name")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertFalse(function.signature.input[0].isOptional)
        XCTAssertFalse(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "String")
        XCTAssertEqual(function.signature.input[0].type, .simple("String"))
        XCTAssertEqual(function.signature.input[0].defaultArgument, "\"name\"")
        XCTAssertEqual(function.signature.input[0].description, "name: String = \"name\"")

        // Optional Result parameter
        // func inoutValue(names: inout [String]) {}
        function = instanceUnderTest.functions[17]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "inoutValue")
        XCTAssertNil(function.signature.throwsOrRethrowsKeyword)
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 1)
        XCTAssertEqual(function.signature.input[0].attributes, [])
        XCTAssertEqual(function.signature.input[0].modifiers, [])
        XCTAssertEqual(function.signature.input[0].name, "names")
        XCTAssertNil(function.signature.input[0].secondName)
        XCTAssertFalse(function.signature.input[0].isLabelOmitted)
        XCTAssertFalse(function.signature.input[0].isVariadic)
        XCTAssertFalse(function.signature.input[0].isOptional)
        XCTAssertTrue(function.signature.input[0].isInOut)
        XCTAssertEqual(function.signature.input[0].rawType, "inout [String]")
        XCTAssertEqual(function.signature.input[0].type, .simple("[String]"))
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].description, "names: inout [String]")
    }

    func test_function_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        func executeOrder66() throws {}
        """#
        let sourceTwo = #"""
        func executeOrder66() throws {}
        """#
        let sourceThree = #"""
        func executeOrder66() throws {}
        static func executeOrder66() throws {}
        func executeOtherOrder() throws {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let sampleOne = instanceUnderTest.functions[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let sampleTwo = instanceUnderTest.functions[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 3)

        let sampleThree = instanceUnderTest.functions[0]
        let sampleFour = instanceUnderTest.functions[1]
        let otherSample = instanceUnderTest.functions[2]

        let equalCases: [(Function, Function)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(Function, Function)] = [
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
