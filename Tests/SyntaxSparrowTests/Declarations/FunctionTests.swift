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

    func test_function_operators() throws {
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
        XCTAssertEqual(prefix.signature.output, .simple("Bool", true))
        XCTAssertEqual(prefix.signature.input.count, 1)
        XCTAssertEqual(prefix.signature.input[0].name, "value")
        XCTAssertNil(prefix.signature.input[0].secondName)
        XCTAssertEqual(prefix.signature.input[0].type, .simple("Bool", false))

        let infix = instanceUnderTest.functions[1]
        XCTAssertTrue(infix.modifiers.isEmpty)
        XCTAssertEqual(infix.identifier, "±")
        XCTAssertTrue(infix.isOperator)
        XCTAssertEqual(infix.operatorKind, .infix)
        XCTAssertEqual(infix.signature.input.count, 2)
        XCTAssertEqual(infix.signature.input[0].name, "lhs")
        XCTAssertNil(infix.signature.input[0].secondName)
        XCTAssertEqual(infix.signature.input[0].type, .simple("Int", true))
        XCTAssertEqual(infix.signature.input[1].name, "rhs")
        XCTAssertNil(infix.signature.input[1].secondName)
        XCTAssertEqual(infix.signature.input[1].type, .simple("Int", false))
        // High level entity type check
        let infixOutput = try XCTUnwrap(infix.signature.output)
        if case let EntityType.tuple(tuple) = infixOutput {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].type, .simple("Int", false))
            XCTAssertEqual(tuple.elements[1].type, .simple("Int", false))
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
        XCTAssertEqual(postfix.signature.input[0].type, .simple("Double", false))
        XCTAssertEqual(postfix.signature.output, .simple("String", false))

        let staticInfix = instanceUnderTest.extensions[0].functions[0]
        XCTAssertEqual(staticInfix.modifiers.count, 1)
        XCTAssertEqual(staticInfix.modifiers[0].name, "static")
        XCTAssertEqual(staticInfix.identifier, "∓")
        XCTAssertTrue(staticInfix.isOperator)
        XCTAssertEqual(staticInfix.operatorKind, .infix)
        XCTAssertEqual(staticInfix.signature.input[0].name, "lhs")
        XCTAssertNil(staticInfix.signature.input[0].secondName)
        XCTAssertEqual(staticInfix.signature.input[0].type, .simple("Int", false))
        XCTAssertEqual(staticInfix.signature.input[1].name, "rhs")
        XCTAssertNil(staticInfix.signature.input[1].secondName)
        XCTAssertEqual(staticInfix.signature.input[1].type, .simple("Int", false))
        // High level entity type check
        let staticInfixOutput = try XCTUnwrap(staticInfix.signature.output)
        if case let EntityType.tuple(tuple) = staticInfixOutput {
            XCTAssertEqual(tuple.elements.count, 2)
            XCTAssertEqual(tuple.elements[0].type, .simple("Int", false))
            XCTAssertEqual(tuple.elements[1].type, .simple("Int", false))
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
}
