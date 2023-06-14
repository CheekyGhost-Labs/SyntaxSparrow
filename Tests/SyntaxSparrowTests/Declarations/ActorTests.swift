//
//  ClassTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ActorTests: XCTestCase {
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
        public actor A {
          public actor B {
            actor C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)
        // A
        var testActor = instanceUnderTest.actors[0]
        XCTAssertEqual(testActor.name, "A")
        XCTAssertEqual(testActor.keyword, "actor")
        XCTAssertEqual(testActor.modifiers.count, 1)
        XCTAssertEqual(testActor.modifiers.first?.name, "public")
        XCTAssertNil(testActor.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (4, 1, 57),
            source: source
        )
        XCTAssertEqual(testActor.actors.count, 1)
        // B
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "B")
        XCTAssertEqual(testActor.keyword, "actor")
        XCTAssertEqual(testActor.modifiers.count, 1)
        XCTAssertEqual(testActor.modifiers.first?.name, "public")
        XCTAssertNil(testActor.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (1, 2, 19),
            end: (3, 3, 55),
            source: "public actor B {\n    actor C { }\n  }"
        )
        XCTAssertEqual(testActor.actors.count, 1)
        // C
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "C")
        XCTAssertEqual(testActor.keyword, "actor")
        XCTAssertEqual(testActor.modifiers.count, 0)
        XCTAssertNil(testActor.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (2, 4, 40),
            end: (2, 15, 51),
            source: "actor C { }"
        )
        XCTAssertEqual(testActor.classes.count, 0)
    }

    func test_standard_withAttributes_willResolveExpectedProperties() throws {
        let attributeExpectations: [(String?, String)] = [
            (nil, "*"),
            (nil, "unavailable"),
            ("message", "\"my message\""),
        ]
        let source = #"""
        @available(*, unavailable, message: "my message")
        actor A {
          actor B {
            @available(*, unavailable, message: "my message")
            actor C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)
        // A
        var testActor = instanceUnderTest.actors[0]
        XCTAssertEqual(testActor.name, "A")
        var attributes = testActor.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertEqual(attributes.arguments.count, 3)
        let classAMap = attributes.arguments.map { ($0.name, $0.value) }
        for (index, arg) in classAMap.enumerated() {
            let expected = attributeExpectations[index]
            XCTAssertEqual(arg.0, expected.0)
            XCTAssertEqual(arg.1, expected.1)
        }
        // B
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "B")
        XCTAssertEqual(testActor.attributes.count, 0)
        // C
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "C")
        XCTAssertEqual(testActor.attributes.count, 1)
        // Attributes
        attributes = testActor.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertEqual(attributes.arguments.count, 3)
        let classCMap = attributes.arguments.map { ($0.name, $0.value) }
        for (index, arg) in classCMap.enumerated() {
            let expected = attributeExpectations[index]
            XCTAssertEqual(arg.0, expected.0)
            XCTAssertEqual(arg.1, expected.1)
        }
    }

    func test_standard_withAttributes_willIncludeAttributesInSourceResolving() throws {
        let source = #"""
        @available(*, unavailable, message: "my message")
        actor A {
          actor B {
            @available(*, unavailable, message: "my message")
            actor C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)
        // A
        var testActor = instanceUnderTest.actors[0]
        XCTAssertEqual(testActor.name, "A")
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (6, 1, 147),
            source: "@available(*, unavailable, message: \"my message\")\nactor A {\n  actor B {\n    @available(*, unavailable, message: \"my message\")\n    actor C { }\n  }\n}"
        )
        // B
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "B")
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (2, 2, 62),
            end: (5, 3, 145),
            source: "actor B {\n    @available(*, unavailable, message: \"my message\")\n    actor C { }\n  }"
        )
        // C
        testActor = testActor.actors[0]
        AssertSourceDetailsEquals(
            getSourceLocation(for: testActor, from: instanceUnderTest),
            start: (3, 4, 76),
            end: (4, 15, 141),
            source: "@available(*, unavailable, message: \"my message\")\n    actor C { }"
        )
    }

    func test_multipleModifiers_willResolveExpectedProperties() throws {
        let source = #"""
        open actor A {
          public final actor B {
            private actor C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)
        // A
        var testActor = instanceUnderTest.actors[0]
        XCTAssertEqual(testActor.name, "A")
        XCTAssertEqual(testActor.modifiers.count, 1)
        XCTAssertEqual(testActor.modifiers.first?.name, "open")
        XCTAssertNil(testActor.modifiers.first?.detail)
        // B
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "B")
        XCTAssertEqual(testActor.modifiers.count, 2)
        XCTAssertEqual(testActor.modifiers[0].name, "public")
        XCTAssertNil(testActor.modifiers[0].detail)
        XCTAssertEqual(testActor.modifiers[1].name, "final")
        XCTAssertNil(testActor.modifiers[1].detail)
        // C
        testActor = testActor.actors[0]
        XCTAssertEqual(testActor.name, "C")
        XCTAssertEqual(testActor.modifiers.count, 1)
        XCTAssertEqual(testActor.modifiers[0].name, "private")
        XCTAssertNil(testActor.modifiers[0].detail)
    }

    func test_inheritance_willResolveExpectedValues() throws {
        let source = #"""
        protocol MyThing {}
        actor A: MyThing {}
        actor B {}
        private actor C: B, MyThing { }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 3)
        // A
        var testActor = instanceUnderTest.actors[0]
        XCTAssertEqual(testActor.name, "A")
        XCTAssertEqual(testActor.inheritance, ["MyThing"])
        // B
        testActor = instanceUnderTest.actors[1]
        XCTAssertEqual(testActor.name, "B")
        XCTAssertEqual(testActor.inheritance, [])
        // C
        testActor = instanceUnderTest.actors[2]
        XCTAssertEqual(testActor.name, "C")
        XCTAssertEqual(testActor.inheritance, ["B", "MyThing"])
    }

    func test_withGenerics_willResolveExpectedValues() throws {
        let source = #"""
        actor MyClass<T: Equatable & Comparable, U> where U: Hashable {
            // actor body here...
        }
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.actors.count, 1)

        let testActor = instanceUnderTest.actors[0]

        // Check actor name
        XCTAssertEqual(testActor.name, "MyClass")

        // Check generic parameters
        XCTAssertEqual(testActor.genericParameters.count, 2)
        let firstGenericParam = testActor.genericParameters[0]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertEqual(firstGenericParam.type, "Equatable & Comparable") // Explicit type in this context
        let secondGenericParam = testActor.genericParameters[1]
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(testActor.genericRequirements.count, 1)

        let genericRequirement = testActor.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "U")
        XCTAssertEqual(genericRequirement.relation, .conformance)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "Hashable")
    }

    func test_withSameTypeGenericRequirement_willResolveExpectedValues() throws {
        let source = #"""
        actor MyClass<T, U> where T == U {
            // actor body here...
        }
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.actors.count, 1)

        let myClass = instanceUnderTest.actors[0]

        // Check actor name
        XCTAssertEqual(myClass.name, "MyClass")

        // Check generic parameters
        XCTAssertEqual(myClass.genericParameters.count, 2)
        let firstGenericParam = myClass.genericParameters[0]
        let secondGenericParam = myClass.genericParameters[1]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertNil(firstGenericParam.type) // No explicit type in this context
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(myClass.genericRequirements.count, 1)

        let genericRequirement = myClass.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "T")
        XCTAssertEqual(genericRequirement.relation, .sameType)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "U")
    }

    func test_withAllChildDeclarations_willResolveExpectedChildren() throws {
        let source = #"""
        actor MyActor {
            struct NestedStruct {}
            actor NestedActor {}
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
        XCTAssertEqual(instanceUnderTest.actors.count, 1)

        let actorUnderTest = instanceUnderTest.actors[0]

        // Check child structures
        XCTAssertEqual(actorUnderTest.structures.count, 1)
        XCTAssertEqual(actorUnderTest.structures[0].name, "NestedStruct")

        // Check child classes
        XCTAssertEqual(actorUnderTest.actors.count, 1)
        XCTAssertEqual(actorUnderTest.actors[0].name, "NestedActor")

        // Check child classes
        XCTAssertEqual(actorUnderTest.classes.count, 1)
        XCTAssertEqual(actorUnderTest.classes[0].name, "NestedClass")

        // Check child enums
        XCTAssertEqual(actorUnderTest.enumerations.count, 1)
        XCTAssertEqual(actorUnderTest.enumerations[0].name, "NestedEnum")

        // Check child type aliases
        XCTAssertEqual(actorUnderTest.typealiases.count, 1)
        XCTAssertEqual(actorUnderTest.typealiases[0].name, "NestedTypeAlias")

        // Check child functions
        XCTAssertEqual(actorUnderTest.functions.count, 1)
        XCTAssertEqual(actorUnderTest.functions[0].identifier, "nestedFunction")

        // Check child variables
        XCTAssertEqual(actorUnderTest.variables.count, 1)
        XCTAssertEqual(actorUnderTest.variables[0].name, "nestedVariable")

        // Check child protocols
        XCTAssertEqual(actorUnderTest.protocols.count, 1)
        XCTAssertEqual(actorUnderTest.protocols[0].name, "NestedProtocol")

        // Check child subscripts
        XCTAssertEqual(actorUnderTest.subscripts.count, 1)
        XCTAssertEqual(actorUnderTest.subscripts[0].keyword, "subscript")

        // Check child initializers
        XCTAssertEqual(actorUnderTest.initializers.count, 1)
        XCTAssertEqual(actorUnderTest.initializers[0].keyword, "init")

        // Check child deinitializers
        XCTAssertEqual(actorUnderTest.deinitializers.count, 1)
        XCTAssertEqual(actorUnderTest.deinitializers[0].keyword, "deinit")

        // Check child operators
        XCTAssertEqual(actorUnderTest.operators.count, 1)
        XCTAssertEqual(actorUnderTest.operators[0].name, "+-")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        actor SampleActor {}
        """#
        let sourceTwo = #"""
        actor SampleActor {}
        """#
        let sourceThree = #"""
        actor SampleActor {}
        public actor SampleActor {}
        actor OtherSampleActor {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)

        let sampleOne = instanceUnderTest.actors[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 1)

        let sampleTwo = instanceUnderTest.actors[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 3)

        let sampleThree = instanceUnderTest.actors[0]
        let sampleFour = instanceUnderTest.actors[1]
        let otherSample = instanceUnderTest.actors[2]

        let equalCases: [(Actor, Actor)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Actor, Actor)] = [
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
