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

    // MARK: - Tests

    func test_standardDeclarations_willResolveExpectedProperties() throws {
        let source = #"""
        prefix operator +++
        infix operator +++
        postfix operator +++
        struct Sample {
            prefix operator +++
        }
        var myName: String = "name"
        #if THING
        enum A {
            case sample(String...)
        }
        #else
        enum B {}
        #endif
        func sample(_ names: String...) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        let variable = instanceUnderTest.variables[0]
        let variableNode = variable.resolver.node.context!.as(VariableDeclSyntax.self)!
        let newTree = SyntaxTree(viewMode: .fixedUp, declarationSyntax: variableNode)
        newTree.collectChildren()
        print(newTree.variables)
        
    }
}
