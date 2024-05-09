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
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "throws")
        AssertSourceDetailsEquals(
            getSourceLocation(for: function, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 45, 67),
            source: "@available(iOS 15, *)\nstatic public func executeOrder66() throws {}"
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
        AssertSourceDetailsEquals(
            getSourceLocation(for: function, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (12, 1, 418),
            source: source
        )
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

    func test_function_operators_willResolveExpectedTypes() throws {
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
        XCTAssertNil(function.signature.effectSpecifiers)
        AssertSourceDetailsEquals(
            getSourceLocation(for: function, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 74, 74),
            source: "func executeOrder66<T: Equatable>(withValue value: T) where T: Hashable {}"
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
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        if let outputType = function.signature.output, case let EntityType.array(array) = outputType {
            XCTAssertEqual(array.declType, .squareBrackets)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("C1.Element"))
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        AssertSourceDetailsEquals(
            getSourceLocation(for: function, from: instanceUnderTest),
            start: (1, 0, 75),
            end: (2, 65, 238),
            source: "func executeOrder66<C1: Collection, C2: Collection>(between lhs: C1, and rhs: C2) -> [C1.Element]\n    where C1.Element: Equatable, C1.Element == C2.Element { ... }"
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

    func test_signatureNode_isParentNode() {
        let source = #"""
        func noParameters() throws {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)
        XCTAssertEqual(instanceUnderTest.functions[0].signature.node, instanceUnderTest.functions[0].node.signature)
    }

    func test_function_inoutWithinClosure_singleClosureInput_resolvesExpectedTypes() {
        let source = #"""
        func closure(_ handler: @escaping (inout Int) -> Void, name: inout String) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)
        let function = instanceUnderTest.functions[0]

        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "closure")
        XCTAssertNil(function.signature.effectSpecifiers)
        XCTAssertEqual(function.signature.input.count, 2)
        // Closure Input with inout input
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
        XCTAssertEqual(function.signature.input[0].rawType, "@escaping (inout Int) -> Void")
        XCTAssertEqual(function.signature.input[0].description, "_ handler: @escaping (inout Int) -> Void")
        // Closure type assessment
        if case let EntityType.closure(closure) = function.signature.input[0].type {
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertFalse(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertFalse(closure.isAutoEscaping)
            XCTAssertEqual(closure.description, "(inout Int) -> Void")
            // Input
            XCTAssertFalse(closure.isVoidInput)
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                // Inout Int
                XCTAssertFalse(tuple.elements[0].isOptional)
                XCTAssertTrue(tuple.elements[0].isInOut)
                XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
                XCTAssertEqual(tuple.elements[0].description, "inout Int")
            } else {
                XCTFail("The closure input should be a tuple type")
            }
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // inout name String
        XCTAssertEqual(function.signature.input[1].attributes.map(\.name), [])
        XCTAssertEqual(function.signature.input[1].attributes.flatMap(\.arguments), [])
        XCTAssertEqual(function.signature.input[1].modifiers, [])
        XCTAssertEqual(function.signature.input[1].name, "name")
        XCTAssertNil(function.signature.input[1].secondName)
        XCTAssertFalse(function.signature.input[1].isLabelOmitted)
        XCTAssertFalse(function.signature.input[1].isVariadic)
        XCTAssertFalse(function.signature.input[1].isOptional)
        XCTAssertTrue(function.signature.input[1].isInOut)
        XCTAssertNil(function.signature.input[1].defaultArgument)
        XCTAssertEqual(function.signature.input[1].type.description, "String")
        XCTAssertEqual(function.signature.input[1].rawType, "inout String")
        XCTAssertEqual(function.signature.input[1].description, "name: inout String")
    }

    func test_function_inoutWithinClosure_multipleClosureInputs_resolvesExpectedTypes() {
        let source = #"""
        func closure(_ handler: @escaping (inout Int, String) -> Void, name: inout String) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)
        let function = instanceUnderTest.functions[0]

        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "closure")
        XCTAssertNil(function.signature.effectSpecifiers)
        XCTAssertEqual(function.signature.input.count, 2)
        // Closure Input with inout input
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
        XCTAssertEqual(function.signature.input[0].rawType, "@escaping (inout Int, String) -> Void")
        XCTAssertEqual(function.signature.input[0].description, "_ handler: @escaping (inout Int, String) -> Void")
        // Closure type assessment
        if case let EntityType.closure(closure) = function.signature.input[0].type {
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertFalse(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertFalse(closure.isAutoEscaping)
            XCTAssertEqual(closure.description, "(inout Int, String) -> Void")
            // Input
            XCTAssertFalse(closure.isVoidInput)
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 2)
                // Inout Int
                XCTAssertFalse(tuple.elements[0].isOptional)
                XCTAssertTrue(tuple.elements[0].isInOut)
                XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
                XCTAssertEqual(tuple.elements[0].description, "inout Int")
                // Standard String
                XCTAssertFalse(tuple.elements[1].isOptional)
                XCTAssertFalse(tuple.elements[1].isInOut)
                XCTAssertEqual(tuple.elements[1].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].description, "String")
            } else {
                XCTFail("The closure input should be a tuple type")
            }
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // inout name String
        XCTAssertEqual(function.signature.input[1].attributes.map(\.name), [])
        XCTAssertEqual(function.signature.input[1].attributes.flatMap(\.arguments), [])
        XCTAssertEqual(function.signature.input[1].modifiers, [])
        XCTAssertEqual(function.signature.input[1].name, "name")
        XCTAssertNil(function.signature.input[1].secondName)
        XCTAssertFalse(function.signature.input[1].isLabelOmitted)
        XCTAssertFalse(function.signature.input[1].isVariadic)
        XCTAssertFalse(function.signature.input[1].isOptional)
        XCTAssertTrue(function.signature.input[1].isInOut)
        XCTAssertNil(function.signature.input[1].defaultArgument)
        XCTAssertEqual(function.signature.input[1].type.description, "String")
        XCTAssertEqual(function.signature.input[1].rawType, "inout String")
        XCTAssertEqual(function.signature.input[1].description, "name: inout String")
    }

    func test_function_parameters_willResolveExpectedTypes() throws {
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
        func asyncAwaitMethod() async {}
        func asyncAwaitMethodThrowing() throws async {}
        func asyncAwaitMethodThrowingReturning() throws async -> String {}
        func arrayShorthand(persons: [(name: String, age: Int?)]?) {}
        func arrayIdentifier(names: Array<String?>) {}
        func arrayIdentifier(names: Array<String?>?) {}
        func setIdentifier(names: Set<String>) {}
        func dictionaryShorthand(persons: [String: (name: String, age: Int?)]?) {}
        func dictionaryIdentifier(names: Dictionary<String, (name: String, age: Int?)>?) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 27)

        // No Parameters
        // func noParameters() throws {}
        var function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "noParameters")
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "throws")
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 0)

        // Label Omitted
        // func labelOmitted(_ name: String) {}
        function = instanceUnderTest.functions[1]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "labelOmitted")
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "throws")
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertEqual(tuple.description, "(name: String, age: Int?)?")
        } else {
            XCTFail("function.signature.input[0] type should be tuple")
        }

        // escaping closure parameter
        // func closure(_ handler: @escaping (Int) -> Void) {}
        function = instanceUnderTest.functions[11]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "closure")
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertFalse(closure.isVoidInput)
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertFalse(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertFalse(closure.isAutoEscaping)
            XCTAssertEqual(closure.description, "(Int) -> Void")
            // Closure Input Tuple (Single Element)
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
                XCTAssertEqual(tuple.elements[0].rawType, "Int")
                XCTAssertFalse(tuple.elements[0].isInOut)
                XCTAssertFalse(tuple.elements[0].isOptional)
                XCTAssertNil(tuple.elements[0].name)
                XCTAssertNil(tuple.elements[0].secondName)
                XCTAssertFalse(tuple.elements[0].isLabelOmitted)
            }
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // auto escaping closure parameter
        // func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
        function = instanceUnderTest.functions[12]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "autoEscapingClosure")
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertFalse(closure.isVoidInput)
            XCTAssertEqual(closure.output, .void("Void", false))
            XCTAssertTrue(closure.isVoidOutput)
            XCTAssertTrue(closure.isOptional)
            XCTAssertTrue(closure.isEscaping)
            XCTAssertTrue(closure.isAutoEscaping)
            XCTAssertEqual(closure.description, "((Int) -> Void)?")
            // Closure Input Tuple (Single Element)
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 1)
                XCTAssertEqual(tuple.elements[0].type, .simple("Int"))
                XCTAssertEqual(tuple.elements[0].rawType, "Int")
                XCTAssertFalse(tuple.elements[0].isInOut)
                XCTAssertFalse(tuple.elements[0].isOptional)
                XCTAssertNil(tuple.elements[0].name)
                XCTAssertNil(tuple.elements[0].secondName)
                XCTAssertFalse(tuple.elements[0].isLabelOmitted)
            }
        } else {
            XCTFail("function.signature.input[0] type should be closure")
        }

        // complex auto escaping closure
        // func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
        function = instanceUnderTest.functions[13]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "complexClosure")
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertEqual(closure.description, "((name: String, age: Int) -> String?)?")
            if case let EntityType.tuple(tuple) = closure.input {
                XCTAssertEqual(tuple.elements.count, 2)
                XCTAssertEqual(tuple.elements[0].name, "name")
                XCTAssertEqual(tuple.elements[0].type, .simple("String"))
                XCTAssertEqual(tuple.elements[1].name, "age")
                XCTAssertEqual(tuple.elements[1].type, .simple("Int"))
                XCTAssertFalse(tuple.isOptional)
                XCTAssertEqual(tuple.description, "(name: String, age: Int)")
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertEqual(result.description, "Result<String, Error>")
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // func resultOptional(processResult: Result<String, Error>?) {}
        function = instanceUnderTest.functions[15]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "resultOptional")
        XCTAssertNil(function.signature.effectSpecifiers)
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
            XCTAssertEqual(result.description, "Result<String, Error>?")
        } else {
            XCTFail("function.signature.input[0] type should be Result")
        }

        // Optional Result parameter
        // func defaultValue(name: String = "name") {}
        function = instanceUnderTest.functions[16]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "defaultValue")
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.effectSpecifiers)
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
        XCTAssertNil(function.signature.input[0].defaultArgument)
        XCTAssertEqual(function.signature.input[0].description, "names: inout [String]")
        if case let EntityType.array(array) = function.signature.input[0].type {
            XCTAssertEqual(array.declType, .squareBrackets)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String"))
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        // async function
        // func asyncAwaitMethod() async {}
        function = instanceUnderTest.functions[18]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "asyncAwaitMethod")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertEqual(function.signature.effectSpecifiers?.asyncSpecifier, "async")
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 0)

        // async throwing function
        // func asyncAwaitMethodThrowing() throws async {}
        function = instanceUnderTest.functions[19]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "asyncAwaitMethodThrowing")
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "throws")
        XCTAssertEqual(function.signature.effectSpecifiers?.asyncSpecifier, "async")
        XCTAssertNil(function.signature.output)
        XCTAssertEqual(function.signature.input.count, 0)

        // async throwing function
        // func asyncAwaitMethodThrowingReturning() throws async -> String {}
        function = instanceUnderTest.functions[20]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "asyncAwaitMethodThrowingReturning")
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "throws")
        XCTAssertEqual(function.signature.effectSpecifiers?.asyncSpecifier, "async")
        XCTAssertEqual(function.signature.output, .simple("String"))
        XCTAssertEqual(function.signature.input.count, 0)

        // func arrayShorthand(persons: [(name: String, age: Int?)]?) {}
        function = instanceUnderTest.functions[21]
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
                XCTAssertEqual(array.description, "[(name: String, age: Int?)]?")
            }
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        // func arrayIdentifier(names: Array<String?>) {}
        function = instanceUnderTest.functions[22]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "arrayIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.array(array) = function.signature.input[0].type {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String?"))
            XCTAssertEqual(array.elementType.description, "String?")
            XCTAssertEqual(array.description, "Array<String?>")
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        // func arrayIdentifier(names: Array<String?>?) {}
        function = instanceUnderTest.functions[23]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "arrayIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.array(array) = function.signature.input[0].type {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertTrue(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("String?"))
            XCTAssertEqual(array.elementType.description, "String?")
            XCTAssertEqual(array.description, "Array<String?>?")
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        // func setIdentifier(names: Set<String>) {}
        function = instanceUnderTest.functions[24]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "setIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.set(set) = function.signature.input[0].type {
            XCTAssertFalse(set.isOptional)
            XCTAssertEqual(set.elementType, .simple("String"))
        } else {
            XCTFail("function.signature.input[0] type should be Set")
        }

        // func dictionaryShorthand(persons: [String: (name: String, age: Int?)]?) {}
        function = instanceUnderTest.functions[25]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "dictionaryShorthand")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.dictionary(dict) = function.signature.input[0].type {
            XCTAssertTrue(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            XCTAssertEqual(dict.declType, .squareBrackets)
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

        // func dictionaryIdentifier(names: Dictionary<String, (name: String, age: Int?)>?) {}
        function = instanceUnderTest.functions[26]
        XCTAssertEqual(function.keyword, "func")
        XCTAssertEqual(function.identifier, "dictionaryIdentifier")
        XCTAssertNil(function.signature.effectSpecifiers?.throwsSpecifier)
        XCTAssertNil(function.signature.effectSpecifiers?.asyncSpecifier)
        XCTAssertEqual(function.signature.input.count, 1)

        if case let EntityType.dictionary(dict) = function.signature.input[0].type {
            XCTAssertTrue(dict.isOptional)
            XCTAssertEqual(dict.keyType, .simple("String"))
            XCTAssertEqual(dict.declType, .generics)
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

    func test_function_outputIsOptional_willResolveExpectedTypes() throws {
        let source = #"""
        func returnTypeNotOptional() -> String {}
        func returnTypeIsOptional() -> String? {}
        func returnTypeNotOptional() -> (() -> Void) {}
        func returnTypeIsOptional() -> (() -> Void)? {}
        func returnTypeNotOptional() -> (name: String, age: Int?) {}
        func returnTypeIsOptional() -> (name: String, age: Int?)? {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 6)
        XCTAssertFalse(instanceUnderTest.functions[0].signature.outputIsOptional)
        XCTAssertTrue(instanceUnderTest.functions[1].signature.outputIsOptional)
        XCTAssertFalse(instanceUnderTest.functions[2].signature.outputIsOptional)
        XCTAssertTrue(instanceUnderTest.functions[3].signature.outputIsOptional)
        XCTAssertFalse(instanceUnderTest.functions[4].signature.outputIsOptional)
        XCTAssertTrue(instanceUnderTest.functions[5].signature.outputIsOptional)
    }

    func test_function_body_willResolveExpectedResult() throws {
        let source = #"""
        func executeOrder66() throws {
            print("hello")
            print("world")
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let body = try XCTUnwrap(instanceUnderTest.functions[0].body)
        XCTAssertEqual(body.statements.count, 2)
        XCTAssertEqual(body.statements[0].kind, CodeBlock.Statement.Kind(body.statements[0].node.item))
        XCTAssertEqual(body.statements[1].kind, CodeBlock.Statement.Kind(body.statements[1].node.item))
    }

    func test_function_throwingClosureParam_rethrowing_willResolveExpectedSpecifiers() {
        let source = #"""
        func performAndWait<T>(_ block: () throws -> T) async rethrows -> T
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let function = instanceUnderTest.functions[0]

        XCTAssertEqual(function.signature.effectSpecifiers?.asyncSpecifier, "async")
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "rethrows")

        if case let EntityType.closure(closure) = function.signature.input[0].type {
            XCTAssertNil(closure.effectSpecifiers?.asyncSpecifier)
            XCTAssertEqual(closure.effectSpecifiers?.throwsSpecifier, "throws")
        } else {
            XCTFail("Function should have a closure parameter")
        }
    }

    func test_function_standardClosureParam_rethrowing_willResolveExpectedSpecifiers() {
        let source = #"""
        func performAndWait<T>(_ block: () -> T) async rethrows -> T
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 1)

        let function = instanceUnderTest.functions[0]

        XCTAssertEqual(function.signature.effectSpecifiers?.asyncSpecifier, "async")
        XCTAssertEqual(function.signature.effectSpecifiers?.throwsSpecifier, "rethrows")

        if case let EntityType.closure(closure) = function.signature.input[0].type {
            XCTAssertNil(closure.effectSpecifiers)
        } else {
            XCTFail("Function should have a closure parameter")
        }
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
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Function, Function)] = [
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

    func test_function_rawOutputType_willResolveExpectedValues() throws {
        let source = #"""
        func example() -> String
        func example() -> String?
        func example() -> (any SomeProtocol)
        func example() -> (any SomeProtocol)?
        func example() -> (String) -> Void
        func example() -> (name: String, age: Int)?
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 6)

        XCTAssertEqual(instanceUnderTest.functions[0].signature.rawOutputType, "String")
        XCTAssertEqual(instanceUnderTest.functions[1].signature.rawOutputType, "String?")
        XCTAssertEqual(instanceUnderTest.functions[2].signature.rawOutputType, "(any SomeProtocol)")
        XCTAssertEqual(instanceUnderTest.functions[3].signature.rawOutputType, "(any SomeProtocol)?")
        XCTAssertEqual(instanceUnderTest.functions[4].signature.rawOutputType, "(String) -> Void")
        XCTAssertEqual(instanceUnderTest.functions[5].signature.rawOutputType, "(name: String, age: Int)?")
    }
}
