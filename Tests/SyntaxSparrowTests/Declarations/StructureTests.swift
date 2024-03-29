//
//  StructureTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class StructureTests: XCTestCase {
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
        struct A {
          struct B {
            struct C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)
        // A
        var structure = instanceUnderTest.structures[0]
        XCTAssertEqual(structure.name, "A")
        XCTAssertEqual(structure.keyword, "struct")
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (4, 1, 46),
            source: source
        )
        XCTAssertEqual(structure.structures.count, 1)
        // B
        structure = structure.structures[0]
        XCTAssertEqual(structure.name, "B")
        XCTAssertEqual(structure.keyword, "struct")
        XCTAssertNil(structure.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (1, 2, 13),
            end: (3, 3, 44),
            source: "struct B {\n    struct C { }\n  }"
        )
        XCTAssertEqual(structure.structures.count, 1)
        // C
        structure = structure.structures[0]
        XCTAssertEqual(structure.name, "C")
        XCTAssertEqual(structure.keyword, "struct")
        XCTAssertEqual(structure.modifiers.count, 0)
        XCTAssertNil(structure.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (2, 4, 28),
            end: (2, 16, 40),
            source: "struct C { }"
        )
        XCTAssertEqual(structure.structures.count, 0)
    }

    func test_withModifiers_willResolveExpectedProperties() throws {
        let source = #"""
        public struct A {
          struct B {
            public struct C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)
        // A
        var structure = instanceUnderTest.structures[0]
        XCTAssertEqual(structure.name, "A")
        XCTAssertEqual(structure.keyword, "struct")
        XCTAssertEqual(structure.modifiers.count, 1)
        XCTAssertEqual(structure.modifiers.first?.name, "public")
        XCTAssertNil(structure.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (4, 1, 60),
            source: "public struct A {\n  struct B {\n    public struct C { }\n  }\n}"
        )
        XCTAssertEqual(structure.structures.count, 1)
        // B
        structure = structure.structures[0]
        XCTAssertEqual(structure.name, "B")
        XCTAssertEqual(structure.keyword, "struct")
        XCTAssertEqual(structure.modifiers.count, 0)
        XCTAssertNil(structure.modifiers.first?.name)
        XCTAssertNil(structure.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (1, 2, 20),
            end: (3, 3, 58),
            source: "struct B {\n    public struct C { }\n  }"
        )
        XCTAssertEqual(structure.structures.count, 1)
        // C
        structure = structure.structures[0]
        XCTAssertEqual(structure.name, "C")
        XCTAssertEqual(structure.keyword, "struct")
        XCTAssertEqual(structure.modifiers.count, 1)
        XCTAssertEqual(structure.modifiers.first?.name, "public")
        XCTAssertNil(structure.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (2, 4, 35),
            end: (2, 23, 54),
            source: "public struct C { }"
        )
        XCTAssertEqual(structure.structures.count, 0)
    }

    func test_withAttributes_willIncludeAttributesInSourceResolving() throws {
        let source = #"""
        @available(*, unavailable, message: "my message")
        struct A {
          struct B {
            @available(*, unavailable, message: "my message")
            struct C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)
        // A
        var structure = instanceUnderTest.structures[0]
        XCTAssertEqual(structure.name, "A")
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (6, 1, 150),
            source: "@available(*, unavailable, message: \"my message\")\nstruct A {\n  struct B {\n    @available(*, unavailable, message: \"my message\")\n    struct C { }\n  }\n}"
        )
        // B
        structure = structure.structures[0]
        XCTAssertEqual(structure.name, "B")
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (2, 2, 63),
            end: (5, 3, 148),
            source: "struct B {\n    @available(*, unavailable, message: \"my message\")\n    struct C { }\n  }"
        )
        // C
        structure = structure.structures[0]
        AssertSourceDetailsEquals(
            getSourceLocation(for: structure, from: instanceUnderTest),
            start: (3, 4, 78),
            end: (4, 16, 144),
            source: "@available(*, unavailable, message: \"my message\")\n    struct C { }"
        )
    }

    func test_standard_withAttributes_willResolveExpectedProperties() throws {
        let attributeExpectations: [(String?, String)] = [
            (nil, "*"),
            (nil, "unavailable"),
            ("message", "\"my message\""),
        ]
        let source = #"""
        @available(*, unavailable, message: "my message")
        struct A {
          struct B {
            @available(*, unavailable, message: "my message")
            struct C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)
        // A
        var structUnderTest = instanceUnderTest.structures[0]
        XCTAssertEqual(structUnderTest.name, "A")
        var attributes = structUnderTest.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertAttributesArgumentsEqual(attributes, attributeExpectations)
        // B
        structUnderTest = structUnderTest.structures[0]
        XCTAssertEqual(structUnderTest.name, "B")
        XCTAssertEqual(structUnderTest.attributes.count, 0)
        // C
        structUnderTest = structUnderTest.structures[0]
        XCTAssertEqual(structUnderTest.name, "C")
        XCTAssertEqual(structUnderTest.attributes.count, 1)
        // Attributes
        attributes = structUnderTest.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertEqual(attributes.arguments.count, 3)
        XCTAssertAttributesArgumentsEqual(attributes, attributeExpectations)
    }

    func test_inheritance_willResolveExpectedValues() throws {
        let source = #"""
        protocol MyThing {}
        struct A: MyThing {}
        struct B {}
        private struct C: Equatable, MyThing { }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 3)
        // A
        var testClass = instanceUnderTest.structures[0]
        XCTAssertEqual(testClass.name, "A")
        XCTAssertEqual(testClass.inheritance, ["MyThing"])
        // B
        testClass = instanceUnderTest.structures[1]
        XCTAssertEqual(testClass.name, "B")
        XCTAssertEqual(testClass.inheritance, [])
        // C
        testClass = instanceUnderTest.structures[2]
        XCTAssertEqual(testClass.name, "C")
        XCTAssertEqual(testClass.inheritance, ["Equatable", "MyThing"])
    }

    func test_equatable_hashable() throws {
        let source = #"""
        struct A {}
                struct B {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 2)
        let structA = instanceUnderTest.structures[0]
        let structB = instanceUnderTest.structures[1]

        XCTAssertNotEqual(structA, structB)
        XCTAssertEqual(structA, structA)
        XCTAssertEqual(structB, structB)
        XCTAssertTrue(structA == structA)
        XCTAssertNotEqual(structA.hashValue, structB.hashValue)
        XCTAssertEqual(structA.hashValue, structA.hashValue)
        XCTAssertEqual(structB.hashValue, structB.hashValue)
    }

    func test_withGenerics_willResolveExpectedValues() throws {
        let source = #"""
        struct MyStruct<T: Equatable & Comparable, U> where U: Hashable {}
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let myStruct = instanceUnderTest.structures[0]

        // Check class name
        XCTAssertEqual(myStruct.name, "MyStruct")

        // Check generic parameters
        XCTAssertEqual(myStruct.genericParameters.count, 2)
        let firstGenericParam = myStruct.genericParameters[0]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertEqual(firstGenericParam.type, "Equatable & Comparable") // Explicit type in this context
        let secondGenericParam = myStruct.genericParameters[1]
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(myStruct.genericRequirements.count, 1)

        let genericRequirement = myStruct.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "U")
        XCTAssertEqual(genericRequirement.relation, .conformance)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "Hashable")
    }

    func test_withSameTypeGenericRequirement_willResolveExpectedValues() throws {
        let source = #"""
        struct MyStruct<T, U> where T == U {}
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let myStruct = instanceUnderTest.structures[0]

        // Check class name
        XCTAssertEqual(myStruct.name, "MyStruct")

        // Check generic parameters
        XCTAssertEqual(myStruct.genericParameters.count, 2)
        let firstGenericParam = myStruct.genericParameters[0]
        let secondGenericParam = myStruct.genericParameters[1]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertNil(firstGenericParam.type) // No explicit type in this context
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(myStruct.genericRequirements.count, 1)

        let genericRequirement = myStruct.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "T")
        XCTAssertEqual(genericRequirement.relation, .sameType)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "U")
    }

    func test_withAllChildDeclarations_willResolveExpectedChildren() throws {
        let source = #"""
        struct MyStruct {
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
        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let structUnderTest = instanceUnderTest.structures[0]

        // Check child structures
        XCTAssertEqual(structUnderTest.childCollection.structures.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.structures[0].name, "NestedStruct")

        // Check child classes
        XCTAssertEqual(structUnderTest.childCollection.classes.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.classes[0].name, "NestedClass")

        // Check child enums
        XCTAssertEqual(structUnderTest.childCollection.enumerations.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.enumerations[0].name, "NestedEnum")

        // Check child type aliases
        XCTAssertEqual(structUnderTest.childCollection.typealiases.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.typealiases[0].name, "NestedTypeAlias")

        // Check child functions
        XCTAssertEqual(structUnderTest.childCollection.functions.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.functions[0].identifier, "nestedFunction")

        // Check child variables
        XCTAssertEqual(structUnderTest.childCollection.variables.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.variables[0].name, "nestedVariable")

        // Check child protocols
        XCTAssertEqual(structUnderTest.childCollection.protocols.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.protocols[0].name, "NestedProtocol")

        // Check child subscripts
        XCTAssertEqual(structUnderTest.childCollection.subscripts.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.subscripts[0].keyword, "subscript")

        // Check child initializers
        XCTAssertEqual(structUnderTest.childCollection.initializers.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.initializers[0].keyword, "init")

        // Check child deinitializers
        XCTAssertEqual(structUnderTest.childCollection.deinitializers.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.deinitializers[0].keyword, "deinit")

        // Check child operators
        XCTAssertEqual(structUnderTest.childCollection.operators.count, 1)
        XCTAssertEqual(structUnderTest.childCollection.operators[0].name, "+-")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        struct SampleStruct { enum Nested: String {} }
        """#
        let sourceTwo = #"""
        struct SampleStruct { enum Nested: String {} }
        """#
        let sourceThree = #"""
        struct SampleStruct { enum Nested: String {} }
        struct SampleStruct { public enum Nested: String {} }
        struct OtherSampleStruct { }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let sampleOne = instanceUnderTest.structures[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 1)

        let sampleTwo = instanceUnderTest.structures[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 3)

        let sampleThree = instanceUnderTest.structures[0]
        let sampleFour = instanceUnderTest.structures[1]
        let otherSample = instanceUnderTest.structures[2]

        let equalCases: [(Structure, Structure)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Structure, Structure)] = [
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
