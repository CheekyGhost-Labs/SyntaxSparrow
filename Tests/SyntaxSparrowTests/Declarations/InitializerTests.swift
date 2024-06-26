//
//  InitializerTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class InitializerTests: XCTestCase {
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

    func test_initializer_withAttributesAndModifiers() throws {
        let source = #"""
        class SomeClass {
            @available(iOS 15, *)
            public required init?(withAge age: Int) throws {}
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let classUnderTest = instanceUnderTest.classes[0]
        XCTAssertEqual(classUnderTest.initializers.count, 1)

        let initializerUnderTest = classUnderTest.initializers[0]

        XCTAssertEqual(initializerUnderTest.keyword, "init")
        XCTAssertTrue(initializerUnderTest.isOptional)
        XCTAssertEqual(initializerUnderTest.effectSpecifiers?.throwsSpecifier, "throws")
        AssertSourceDetailsEquals(
            getSourceLocation(for: initializerUnderTest, from: instanceUnderTest),
            start: (1, 4, 22),
            end: (2, 53, 97),
            source: "@available(iOS 15, *)\n    public required init?(withAge age: Int) throws {}"
        )

        // Test parameters
        XCTAssertEqual(initializerUnderTest.parameters.count, 1)
        XCTAssertEqual(initializerUnderTest.parameters[0].type, .simple("Int"))
        XCTAssertEqual(initializerUnderTest.parameters[0].name, "withAge")
        XCTAssertEqual(initializerUnderTest.parameters[0].secondName, "age")
        // Parameters have more extensive tests for initializer parameters

        // Test attributes
        XCTAssertEqual(initializerUnderTest.attributes.count, 1)
        let attributeUnderTest = initializerUnderTest.attributes[0]
        XCTAssertEqual(attributeUnderTest.name, "available")

        // Test modifiers
        XCTAssertEqual(initializerUnderTest.modifiers.count, 2)
        XCTAssertEqual(initializerUnderTest.modifiers[0].name, "public")
        XCTAssertEqual(initializerUnderTest.modifiers[1].name, "required")
    }

    func test_basic_willResolveExpectedProperties() throws {
        let source = #"""
        public init() {
            struct NestedStruct {}
            class NestedClass {}
            enum NestedEnum { case nested }
            typealias NestedTypeAlias = String
            func nestedFunction() {}
            var nestedVariable: Int = 0
            protocol NestedProtocol {}
            subscript(nestedSubscript idx: Int) -> Int { return idx }
            deinit { print("Nested deinit") }
            infix operator +-: NestedOperator
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 1)
        // Test instance
        let initUnderTest = instanceUnderTest.initializers[0]
        // Children
        XCTAssertEqual(initUnderTest.structures.count, 1)
        XCTAssertEqual(initUnderTest.structures[0].name, "NestedStruct")
        XCTAssertEqual(initUnderTest.classes.count, 1)
        XCTAssertEqual(initUnderTest.classes[0].name, "NestedClass")
        XCTAssertEqual(initUnderTest.enumerations.count, 1)
        XCTAssertEqual(initUnderTest.enumerations[0].name, "NestedEnum")
        XCTAssertEqual(initUnderTest.typealiases.count, 1)
        XCTAssertEqual(initUnderTest.typealiases[0].name, "NestedTypeAlias")
        XCTAssertEqual(initUnderTest.functions.count, 1)
        XCTAssertEqual(initUnderTest.functions[0].identifier, "nestedFunction")
        XCTAssertEqual(initUnderTest.variables.count, 1)
        XCTAssertEqual(initUnderTest.variables[0].name, "nestedVariable")
        XCTAssertEqual(initUnderTest.protocols.count, 1)
        XCTAssertEqual(initUnderTest.protocols[0].name, "NestedProtocol")
        XCTAssertEqual(initUnderTest.subscripts.count, 1)
        XCTAssertEqual(initUnderTest.subscripts[0].keyword, "subscript")
        XCTAssertEqual(initUnderTest.deinitializers.count, 1)
        XCTAssertEqual(initUnderTest.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(initUnderTest.operators.count, 1)
        XCTAssertEqual(initUnderTest.operators[0].name, "+-")
    }

    func test_initializer_withConvenience() throws {
        let source = #"""
        class SomeClass {
            @available(iOS 15, *)
            public convenience init(withAge age: Int) throws {}
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let classUnderTest = instanceUnderTest.classes[0]
        XCTAssertEqual(classUnderTest.initializers.count, 1)

        let initializerUnderTest = classUnderTest.initializers[0]

        XCTAssertEqual(initializerUnderTest.keyword, "init")
        XCTAssertFalse(initializerUnderTest.isOptional)
        XCTAssertEqual(initializerUnderTest.effectSpecifiers?.throwsSpecifier, "throws")

        // Test parameters
        XCTAssertEqual(initializerUnderTest.parameters.count, 1)
        XCTAssertEqual(initializerUnderTest.parameters[0].type, .simple("Int"))
        XCTAssertEqual(initializerUnderTest.parameters[0].name, "withAge")
        XCTAssertEqual(initializerUnderTest.parameters[0].secondName, "age")
        // Parameters have more extensive tests for initializer parameters

        // Test attributes
        XCTAssertEqual(initializerUnderTest.attributes.count, 1)
        let attributeUnderTest = initializerUnderTest.attributes[0]
        XCTAssertEqual(attributeUnderTest.name, "available")

        // Test modifiers
        XCTAssertEqual(initializerUnderTest.modifiers.count, 2)
        XCTAssertEqual(initializerUnderTest.modifiers[0].name, "public")
        XCTAssertEqual(initializerUnderTest.modifiers[1].name, "convenience")
    }

    func test_initializer_withGenericParametersAndRequirements() throws {
        let source = #"""
        struct SomeStruct {
            init<T: Equatable>(value: T) where T: Hashable {}
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let structUnderTest = instanceUnderTest.structures[0]
        XCTAssertEqual(structUnderTest.initializers.count, 1)

        let initializerUnderTest = structUnderTest.initializers[0]

        // Test parameters
        XCTAssertEqual(initializerUnderTest.parameters.count, 1)
        XCTAssertEqual(initializerUnderTest.parameters[0].type, .simple("T"))
        XCTAssertEqual(initializerUnderTest.parameters[0].name, "value")
        XCTAssertNil(initializerUnderTest.parameters[0].secondName)
        // Parameters have more extensive tests for initializer parameters

        // Test generic parameters
        XCTAssertEqual(initializerUnderTest.genericParameters.count, 1)
        XCTAssertEqual(initializerUnderTest.genericParameters[0].name, "T")
        XCTAssertEqual(initializerUnderTest.genericParameters[0].type, "Equatable")

        // Test generic requirements
        XCTAssertEqual(initializerUnderTest.genericRequirements.count, 1)
        XCTAssertEqual(initializerUnderTest.genericRequirements[0].relation, .conformance)
        XCTAssertEqual(initializerUnderTest.genericRequirements[0].leftTypeIdentifier, "T")
        XCTAssertEqual(initializerUnderTest.genericRequirements[0].rightTypeIdentifier, "Hashable")
    }

    func test_effectSpecifiers_willReturnExpectedResults() throws {
        let source = #"""
        init() {}
        init() throws {}
        init() async {}
        init() async throws {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 4)

        // None
        XCTAssertFalse(instanceUnderTest.initializers[0].isThrowing)
        XCTAssertFalse(instanceUnderTest.initializers[0].isAsync)
        // Throwing only
        XCTAssertTrue(instanceUnderTest.initializers[1].isThrowing)
        XCTAssertFalse(instanceUnderTest.initializers[1].isAsync)
        // Async only
        XCTAssertFalse(instanceUnderTest.initializers[2].isThrowing)
        XCTAssertTrue(instanceUnderTest.initializers[2].isAsync)
        // Both
        XCTAssertTrue(instanceUnderTest.initializers[3].isThrowing)
        XCTAssertTrue(instanceUnderTest.initializers[3].isAsync)
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        public required init?(withAge age: Int) throws {}
        """#
        let sourceTwo = #"""
        public required init?(withAge age: Int) throws {}
        """#
        let sourceThree = #"""
        public required init?(withAge age: Int) throws {}
        public required init?(withAge age: Int) {}
        public required init(withAge age: Int) throws {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 1)

        let sampleOne = instanceUnderTest.initializers[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 1)

        let sampleTwo = instanceUnderTest.initializers[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 3)

        let sampleThree = instanceUnderTest.initializers[0]
        let sampleFour = instanceUnderTest.initializers[1]
        let otherSample = instanceUnderTest.initializers[2]

        let equalCases: [(Initializer, Initializer)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Initializer, Initializer)] = [
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
