//
//  SyntaxTreeTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import XCTest
import SwiftSyntax
import SyntaxSparrow

final class SyntaxTreeTests: XCTestCase {

    // MARK: - Lifecycle

    func test_resolvingFromSourceConvenience_willReturnExpectedValues() throws {
        let source = #"""
        struct MyStruct {}
        class MyClass {}
        enum MyEnum { case nested }
        typealias MyTypeAlias = String
        func nestedFunction() {}
        var nestedVariable: Int = 0
        protocol NestedProtocol {}
        subscript(nestedSubscript idx: Int) -> Int { return idx }
        init(nestedInitializer: Int) {}
        deinit { print("Nested deinit") }
        infix operator +-: NestedOperator
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        """#
        XCTAssertEqual(SyntaxTree.declarations(of: Class.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Structure.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Enumeration.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Typealias.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Function.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Variable.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: ProtocolDecl.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Subscript.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Initializer.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Deinitializer.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: Operator.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: PrecedenceGroup.self, inSource: source).count, 1)
        XCTAssertEqual(SyntaxTree.declarations(of: ConditionalCompilationBlock.self, inSource: source).count, 1)
    }

    func test_resolvingFromDeclarationSyntax_willReturnExpectedValue() {
        let source = #"""
        struct MyStruct {}
        class MyClass {}
        enum MyEnum { case nested }
        typealias MyTypeAlias = String
        func nestedFunction() {}
        var nestedVariable: Int = 0
        protocol NestedProtocol {}
        subscript(nestedSubscript idx: Int) -> Int { return idx }
        init(nestedInitializer: Int) {}
        deinit { print("Nested deinit") }
        infix operator +-: NestedOperator
        precedencegroup CongruentPrecedence {
            lowerThan: MultiplicationPrecedence
            higherThan: AdditionPrecedence
            associativity: left
            assignment: true
        }
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        """#
        let tree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: source)
        tree.collectChildren()
        //
        XCTAssertNotNil(SyntaxTree.declaration(of: Class.self, fromSyntax: tree.classes[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Structure.self, fromSyntax: tree.structures[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Enumeration.self, fromSyntax: tree.enumerations[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Typealias.self, fromSyntax: tree.typealiases[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Function.self, fromSyntax: tree.functions[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Variable.self, fromSyntax: tree.variables[0].parentDeclarationSyntax!))
        XCTAssertNotNil(SyntaxTree.declaration(of: ProtocolDecl.self, fromSyntax: tree.protocols[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Subscript.self, fromSyntax: tree.subscripts[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Initializer.self, fromSyntax: tree.initializers[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Deinitializer.self, fromSyntax: tree.deinitializers[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: Operator.self, fromSyntax: tree.operators[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: PrecedenceGroup.self, fromSyntax: tree.precedenceGroups[0].node))
        XCTAssertNotNil(SyntaxTree.declaration(of: ConditionalCompilationBlock.self, fromSyntax: tree.conditionalCompilationBlocks[0].node))
    }

    func test_resolvingFromDeclarationSyntax_array_willReturnExpectedValue() {
        let source = #"""
        var firstName: String, secondName: String
        """#
        let tree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: source)
        tree.collectChildren()
        //
        let variableDecl = tree.variables[0].parentDeclarationSyntax!
        XCTAssertEqual(SyntaxTree.declarations(of: Variable.self, fromSyntax: variableDecl).count, 2)
    }
}
