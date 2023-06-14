//
//  ConditionalCompilationBlockTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SwiftSyntax
@testable import SyntaxSparrow
import XCTest

final class ConditionalCompilationBlockTests: XCTestCase {
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

    func test_standardConditionalCompilationBlock_willResolveExpectedProperties() throws {
        let source = #"""
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 1)
        // Block
        let block = instanceUnderTest.conditionalCompilationBlocks[0]
        AssertSourceDetailsEquals(
            getSourceLocation(for: block, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (4, 6, 57),
            source: source
        )
        // Branches
        XCTAssertEqual(block.branches.count, 2)
        // First branch
        var branch = block.branches[0]
        XCTAssertEqual(branch.keyword, .if)
        XCTAssertEqual(branch.condition, "DEBUG")
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 16, 26),
            source: "#if DEBUG\nlet debug = true"
        )
        // Second branch
        branch = block.branches[1]
        XCTAssertEqual(branch.keyword, .else)
        XCTAssertNil(branch.condition)
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (2, 0, 27),
            end: (3, 17, 50),
            source: "#else\nlet debug = false"
        )
    }

    func test_conditionalCompilationBlock_withNestedBlocks_willResolveExpectedProperties() throws {
        let source = #"""
        #if os(macOS)
        print("Hello, macOS!")
        #elseif os(iOS)
        #if targetEnvironment(simulator)
        print("Hello, iOS Simulator!")
        #else
        print("Hello, iOS!")
        #endif
        #else
        print("Hello, unknown OS!")
        #endif
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 1)
        // First block
        let rootBlock = instanceUnderTest.conditionalCompilationBlocks[0]
        XCTAssertEqual(rootBlock.branches.count, 3)
        AssertSourceDetailsEquals(
            getSourceLocation(for: rootBlock, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (10, 6, 191),
            source: source
        )
        // First block: branches
        XCTAssertEqual(rootBlock.branches.count, 3)
        // First block: First branch
        var branch = rootBlock.branches[0]
        XCTAssertEqual(branch.keyword, .if)
        XCTAssertEqual(branch.condition, "os(macOS)")
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 22, 36),
            source: "#if os(macOS)\nprint(\"Hello, macOS!\")"
        )
        // First block: Second branch
        branch = rootBlock.branches[1]
        XCTAssertEqual(branch.keyword, .elseif)
        XCTAssertEqual(branch.condition, "os(iOS)")
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (2, 0, 37),
            end: (7, 6, 150),
            source: "#elseif os(iOS)\n#if targetEnvironment(simulator)\nprint(\"Hello, iOS Simulator!\")\n#else\nprint(\"Hello, iOS!\")\n#endif"
        )
        // First block: Second branch: Block
        XCTAssertEqual(branch.conditionalCompilationBlocks.count, 1)
        let nestedBlock = branch.conditionalCompilationBlocks[0]
        XCTAssertEqual(nestedBlock.branches.count, 2)
        // Nested Block: First branch
        branch = nestedBlock.branches[0]
        XCTAssertEqual(branch.keyword, .if)
        XCTAssertEqual(branch.condition, "targetEnvironment(simulator)")
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (3, 0, 53),
            end: (4, 30, 116),
            source: "#if targetEnvironment(simulator)\nprint(\"Hello, iOS Simulator!\")"
        )
        // Nested Block: Second branch
        branch = nestedBlock.branches[1]
        XCTAssertEqual(branch.keyword, .else)
        XCTAssertNil(branch.condition)
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (5, 0, 117),
            end: (6, 20, 143),
            source: "#else\nprint(\"Hello, iOS!\")"
        )

        // First block: Third branch
        branch = rootBlock.branches[2]
        XCTAssertEqual(branch.keyword, .else)
        XCTAssertNil(branch.condition)
        AssertSourceDetailsEquals(
            getSourceLocation(for: branch, from: instanceUnderTest),
            start: (8, 0, 151),
            end: (9, 27, 184),
            source: "#else\nprint(\"Hello, unknown OS!\")"
        )
    }

    func test_conditionalCompilationBlock_collectsDeclarations() throws {
        let source = #"""
        #if DEBUG
        typealias StringAlias = String
        struct DebugStruct { }
        class DebugClass { }
        enum DebugEnum { case debug }
        func debugFunction() { }
        var debugVariable: Int = 0
        protocol DebugProtocol { }
        subscript(_ idx: Int) -> Int { return idx }
        init() { }
        deinit { print("Debug deinit") }
        infix operator +-: DebugOperator
        extension String {}
        #else
        typealias IntAlias = Int
        struct ReleaseStruct { }
        class ReleaseClass { }
        enum ReleaseEnum { case release }
        func releaseFunction() { }
        var releaseVariable: Int = 0
        protocol ReleaseProtocol { }
        subscript(_ idx: Int) -> Int { return idx }
        init() { }
        deinit { print("Release deinit") }
        infix operator --: ReleaseOperator
        extension Int {}
        #endif
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 1)
        // First block
        let block = instanceUnderTest.conditionalCompilationBlocks[0]
        // Block branches
        XCTAssertEqual(block.branches.count, 2)
        // First branch
        let debugBranch = block.branches[0]
        XCTAssertEqual(debugBranch.typealiases.count, 1)
        XCTAssertEqual(debugBranch.typealiases[0].name, "StringAlias")
        XCTAssertEqual(debugBranch.structures.count, 1)
        XCTAssertEqual(debugBranch.structures[0].name, "DebugStruct")
        XCTAssertEqual(debugBranch.classes.count, 1)
        XCTAssertEqual(debugBranch.classes[0].name, "DebugClass")
        XCTAssertEqual(debugBranch.enumerations.count, 1)
        XCTAssertEqual(debugBranch.enumerations[0].name, "DebugEnum")
        XCTAssertEqual(debugBranch.extensions.count, 1)
        XCTAssertEqual(debugBranch.extensions[0].extendedType, "String")
        XCTAssertEqual(debugBranch.functions.count, 1)
        XCTAssertEqual(debugBranch.functions[0].identifier, "debugFunction")
        XCTAssertEqual(debugBranch.variables.count, 1)
        XCTAssertEqual(debugBranch.variables[0].name, "debugVariable")
        XCTAssertEqual(debugBranch.protocols.count, 1)
        XCTAssertEqual(debugBranch.protocols[0].name, "DebugProtocol")
        XCTAssertEqual(debugBranch.subscripts.count, 1)
        XCTAssertEqual(debugBranch.subscripts[0].keyword, "subscript")
        XCTAssertEqual(debugBranch.initializers.count, 1)
        XCTAssertEqual(debugBranch.initializers[0].keyword, "init")
        XCTAssertEqual(debugBranch.deinitializers.count, 1)
        XCTAssertEqual(debugBranch.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(debugBranch.operators.count, 1)
        XCTAssertEqual(debugBranch.operators[0].name, "+-")
        // Second branch
        let releaseBranch = block.branches[1]
        XCTAssertEqual(releaseBranch.typealiases.count, 1)
        XCTAssertEqual(releaseBranch.typealiases[0].name, "IntAlias")
        XCTAssertEqual(releaseBranch.structures.count, 1)
        XCTAssertEqual(releaseBranch.structures[0].name, "ReleaseStruct")
        XCTAssertEqual(releaseBranch.classes.count, 1)
        XCTAssertEqual(releaseBranch.classes[0].name, "ReleaseClass")
        XCTAssertEqual(releaseBranch.enumerations.count, 1)
        XCTAssertEqual(releaseBranch.enumerations[0].name, "ReleaseEnum")
        XCTAssertEqual(releaseBranch.extensions.count, 1)
        XCTAssertEqual(releaseBranch.extensions[0].extendedType, "Int")
        XCTAssertEqual(releaseBranch.functions.count, 1)
        XCTAssertEqual(releaseBranch.functions[0].identifier, "releaseFunction")
        XCTAssertEqual(releaseBranch.variables.count, 1)
        XCTAssertEqual(releaseBranch.variables[0].name, "releaseVariable")
        XCTAssertEqual(releaseBranch.protocols.count, 1)
        XCTAssertEqual(releaseBranch.protocols[0].name, "ReleaseProtocol")
        XCTAssertEqual(releaseBranch.subscripts.count, 1)
        XCTAssertEqual(releaseBranch.subscripts[0].keyword, "subscript")
        XCTAssertEqual(releaseBranch.initializers.count, 1)
        XCTAssertEqual(releaseBranch.initializers[0].keyword, "init")
        XCTAssertEqual(releaseBranch.deinitializers.count, 1)
        XCTAssertEqual(releaseBranch.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(releaseBranch.operators.count, 1)
        XCTAssertEqual(releaseBranch.operators[0].name, "--")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        """#
        let sourceTwo = #"""
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        """#
        let sourceThree = #"""
        #if DEBUG
        let debug = true
        #else
        let debug = false
        #endif
        #if DEBUG
        let debug = false
        #else
        let debug = true
        #endif
        #if THING
        let thing = true
        #else
        let thing = true
        #endif
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 1)

        let sampleOne = instanceUnderTest.conditionalCompilationBlocks[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 1)

        let sampleTwo = instanceUnderTest.conditionalCompilationBlocks[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.conditionalCompilationBlocks.count, 3)

        let sampleThree = instanceUnderTest.conditionalCompilationBlocks[0]
        let sampleFour = instanceUnderTest.conditionalCompilationBlocks[1]
        let otherSample = instanceUnderTest.conditionalCompilationBlocks[2]

        let equalCases: [(ConditionalCompilationBlock, ConditionalCompilationBlock)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(ConditionalCompilationBlock, ConditionalCompilationBlock)] = [
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
        // Branches
        let equalBranchCases: [(ConditionalCompilationBlock.Branch, ConditionalCompilationBlock.Branch)] = [
            (sampleOne.branches[0], sampleTwo.branches[0]),
            (sampleOne.branches[1], sampleTwo.branches[1]),
            (sampleOne.branches[0], sampleThree.branches[0]),
            (sampleOne.branches[1], sampleThree.branches[1]),
            (sampleTwo.branches[0], sampleThree.branches[0]),
            (sampleTwo.branches[1], sampleThree.branches[1]),
        ]
        let notEqualBranchCases: [(ConditionalCompilationBlock.Branch, ConditionalCompilationBlock.Branch)] = [
            (sampleOne.branches[0], sampleFour.branches[0]),
            (sampleOne.branches[1], sampleFour.branches[1]),
            (sampleOne.branches[0], otherSample.branches[0]),
            (sampleOne.branches[1], otherSample.branches[1]),
            (sampleTwo.branches[0], sampleFour.branches[0]),
            (sampleTwo.branches[1], sampleFour.branches[1]),
            (sampleTwo.branches[0], otherSample.branches[0]),
            (sampleTwo.branches[1], otherSample.branches[1]),
            (sampleThree.branches[0], sampleFour.branches[0]),
            (sampleThree.branches[1], sampleFour.branches[1]),
            (sampleThree.branches[0], otherSample.branches[0]),
            (sampleThree.branches[1], otherSample.branches[1]),
        ]
        equalBranchCases.forEach {
            XCTAssertEqual($0.0, $0.1)
            XCTAssertEqual($0.0.hashValue, $0.1.hashValue)
        }
        notEqualBranchCases.forEach {
            XCTAssertNotEqual($0.0, $0.1)
            XCTAssertNotEqual($0.0.hashValue, $0.1.hashValue)
        }
    }
}
