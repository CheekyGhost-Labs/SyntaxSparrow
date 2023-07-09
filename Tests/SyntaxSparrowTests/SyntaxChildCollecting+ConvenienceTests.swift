//
//  SyntaxChildCollectingConvenienceTests.swift
//
//
//  Created by Michael O'Brien on 9/7/2023.
//

import SwiftSyntax
import SyntaxSparrow
import XCTest

final class SyntaxChildCollectingConvenienceTests: XCTestCase {
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

    func test_recursivelyCollectDeclarations_willResolveExpectedChildDeclarations() throws {
        let source = #"""
        enum Container {
            typealias NestedTypeAliasOne = String
            actor NestedActorOne {}
            func executeOrder66() {

                struct NestedStructOne {

                    typealias NestedTypeAliasTwo = String

                    func executeOrder66Two() {
                        struct NestedStructTwo {}
                        class NestedClassOne {
                            init(nestedInitializerOne: Int) {}
                            deinit { print("Nested deinit one") }
                        }
                        enum NestedEnumOne { case nested }
                        actor NestedActorTwo {}
                        typealias NestedTypeAliasThree = String
                        func nestedFunctionOne() {}
                        var nestedVariableOne: Int = 0
                        infix operator ++: NestedOperatorOne
                        subscript(nestedSubscriptOne idx: Int) -> Int { return idx }
                        func executeOrder66Three() {
                            struct NestedStructThree {}
                            class NestedClassTwo {}
                            enum NestedEnumTwo { case nested }
                            typealias NestedTypeAliasFour = String
                            func nestedFunctionTwo() {}
                            var nestedVariableTwo: Int = 0
                        }
                    }
                }
                #if NESTED_CONDITIONAL_ONE
                print("nested")
                #else
                print("nested")
                #endif

                class NestedClassThree {}
                enum NestedEnumThree { case nested }
                typealias NestedTypeAliasFive = String
                func nestedFunctionThree() {}
                var nestedVariableThree: Int = 0
                protocol NestedProtocol {}
                subscript(nestedSubscriptTwo idx: Int) -> Int { return idx }
                init(nestedInitializerTwo: Int) {}
                deinit { print("Nested deinit two") }
                infix operator +-: NestedOperatorTwo
                deinit {
                    print("Nested deinit three")
                    #if NESTED_CONDITIONAL_TWO
                    print("nested")
                    #else
                    print("nested")
                    #endif
                    var nestedVariableFour: Int = 0
                }
            }
            typealias NestedTypeAliasSix = String
            actor NestedActorThree {}
            #if NESTED_CONDITIONAL_THREE
            print("nested")
            #else
            print("nested")
            #endif
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 1)
        // Enums
        let enums = instanceUnderTest.recursivelyCollectDeclarations(of: Enumeration.self)
        XCTAssertEqual(enums.count, 4)
        XCTAssertEqual(enums.map(\.name), ["Container", "NestedEnumOne", "NestedEnumTwo", "NestedEnumThree"])
        // Typealiases
        let aliases = instanceUnderTest.recursivelyCollectDeclarations(of: Typealias.self)
        XCTAssertEqual(aliases.count, 6)
        XCTAssertEqual(aliases.map(\.name), [
            "NestedTypeAliasOne", "NestedTypeAliasTwo", "NestedTypeAliasThree", "NestedTypeAliasFour", "NestedTypeAliasFive", "NestedTypeAliasSix"
        ])
        // Functions
        let functions = instanceUnderTest.recursivelyCollectDeclarations(of: Function.self)
        XCTAssertEqual(functions.count, 6)
        XCTAssertEqual(functions.map(\.identifier), [
            "executeOrder66", "executeOrder66Two", "nestedFunctionOne", "executeOrder66Three", "nestedFunctionTwo", "nestedFunctionThree"
        ])
        // Structs
        let structures = instanceUnderTest.recursivelyCollectDeclarations(of: Structure.self)
        XCTAssertEqual(structures.count, 3)
        XCTAssertEqual(structures.map(\.name), ["NestedStructOne", "NestedStructTwo", "NestedStructThree"])
        // Classes
        let classes = instanceUnderTest.recursivelyCollectDeclarations(of: Class.self)
        XCTAssertEqual(classes.count, 3)
        XCTAssertEqual(classes.map(\.name), ["NestedClassOne", "NestedClassTwo", "NestedClassThree"])
        // Variables
        let variables = instanceUnderTest.recursivelyCollectDeclarations(of: Variable.self)
        XCTAssertEqual(variables.count, 4)
        XCTAssertEqual(variables.map(\.name), ["nestedVariableOne", "nestedVariableTwo", "nestedVariableThree", "nestedVariableFour"])
        // Subscripts
        let subscripts = instanceUnderTest.recursivelyCollectDeclarations(of: Subscript.self)
        let indexNames = subscripts.flatMap { $0.indices.compactMap(\.name) }
        XCTAssertEqual(subscripts.count, 2)
        XCTAssertEqual(indexNames, ["nestedSubscriptOne", "nestedSubscriptTwo"])
        // Actors
        let actors = instanceUnderTest.recursivelyCollectDeclarations(of: Actor.self)
        XCTAssertEqual(actors.count, 3)
        XCTAssertEqual(actors.map(\.name), ["NestedActorOne", "NestedActorTwo", "NestedActorThree"])
        // Initializers
        let inits = instanceUnderTest.recursivelyCollectDeclarations(of: Initializer.self)
        let inputNames = inits.flatMap { $0.parameters.compactMap(\.name) }
        XCTAssertEqual(inits.count, 2)
        XCTAssertEqual(inputNames, ["nestedInitializerOne", "nestedInitializerTwo"])
        // DeInitializers
        let deinits = instanceUnderTest.recursivelyCollectDeclarations(of: Deinitializer.self)
        let bodyStatements = deinits.flatMap { $0.body!.statements.map(\.description) }
        XCTAssertEqual(inits.count, 2)
        XCTAssertTrue(bodyStatements[0].contains("Nested deinit one"))
        XCTAssertTrue(bodyStatements[1].contains("Nested deinit two"))
        XCTAssertTrue(bodyStatements[2].contains("Nested deinit three"))
        // Operator
        let ops = instanceUnderTest.recursivelyCollectDeclarations(of: Operator.self)
        XCTAssertEqual(ops.count, 2)
        XCTAssertEqual(ops.map(\.name), ["++", "+-"])
        // Conditionals
        let conditionals = instanceUnderTest.recursivelyCollectDeclarations(of: ConditionalCompilationBlock.self)
        let branchConditions = conditionals.flatMap { $0.branches.compactMap(\.condition)}
        XCTAssertEqual(conditionals.count, 3)
        XCTAssertEqual(branchConditions, ["NESTED_CONDITIONAL_ONE", "NESTED_CONDITIONAL_TWO", "NESTED_CONDITIONAL_THREE"])
    }
}
