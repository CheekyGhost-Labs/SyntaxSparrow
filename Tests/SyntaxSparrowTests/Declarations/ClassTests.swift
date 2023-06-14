//
//  ClassTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ClassTests: XCTestCase {
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
        public class A {
          public class B {
            class C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)
        // A
        var testClass = instanceUnderTest.classes[0]
        XCTAssertEqual(testClass.name, "A")
        XCTAssertEqual(testClass.keyword, "class")
        XCTAssertEqual(testClass.modifiers.count, 1)
        XCTAssertEqual(testClass.modifiers.first?.name, "public")
        XCTAssertNil(testClass.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (4, 1, 57),
            source: source
        )
        XCTAssertEqual(testClass.classes.count, 1)
        // B
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "B")
        XCTAssertEqual(testClass.keyword, "class")
        XCTAssertEqual(testClass.modifiers.count, 1)
        XCTAssertEqual(testClass.modifiers.first?.name, "public")
        XCTAssertNil(testClass.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (1, 2, 19),
            end: (3, 3, 55),
            source: "public class B {\n    class C { }\n  }"
        )
        XCTAssertEqual(testClass.classes.count, 1)
        // C
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "C")
        XCTAssertEqual(testClass.keyword, "class")
        XCTAssertEqual(testClass.modifiers.count, 0)
        XCTAssertNil(testClass.modifiers.first?.detail)
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (2, 4, 40),
            end: (2, 15, 51),
            source: "class C { }"
        )
        XCTAssertEqual(testClass.classes.count, 0)
    }

    func test_standard_withAttributes_willResolveExpectedProperties() throws {
        let attributeExpectations: [(String?, String)] = [
            (nil, "*"),
            (nil, "unavailable"),
            ("message", "\"my message\""),
        ]
        let source = #"""
        @available(*, unavailable, message: "my message")
        class A {
          class B {
            @available(*, unavailable, message: "my message")
            class C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)
        // A
        var testClass = instanceUnderTest.classes[0]
        XCTAssertEqual(testClass.name, "A")
        var attributes = testClass.attributes[0]
        XCTAssertEqual(attributes.name, "available")
        XCTAssertEqual(attributes.arguments.count, 3)
        let classAMap = attributes.arguments.map { ($0.name, $0.value) }
        for (index, arg) in classAMap.enumerated() {
            let expected = attributeExpectations[index]
            XCTAssertEqual(arg.0, expected.0)
            XCTAssertEqual(arg.1, expected.1)
        }
        // B
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "B")
        XCTAssertEqual(testClass.attributes.count, 0)
        // C
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "C")
        XCTAssertEqual(testClass.attributes.count, 1)
        // Attributes
        attributes = testClass.attributes[0]
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
        class A {
          class B {
            @available(*, unavailable, message: "my message")
            class C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)
        // A
        var testClass = instanceUnderTest.classes[0]
        XCTAssertEqual(testClass.name, "A")
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (6, 1, 147),
            source: "@available(*, unavailable, message: \"my message\")\nclass A {\n  class B {\n    @available(*, unavailable, message: \"my message\")\n    class C { }\n  }\n}"
        )
        // B
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "B")
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (2, 2, 62),
            end: (5, 3, 145),
            source: "class B {\n    @available(*, unavailable, message: \"my message\")\n    class C { }\n  }"
        )
        // C
        testClass = testClass.classes[0]
        AssertSourceDetailsEquals(
            getSourceLocation(for: testClass, from: instanceUnderTest),
            start: (3, 4, 76),
            end: (4, 15, 141),
            source: "@available(*, unavailable, message: \"my message\")\n    class C { }"
        )
    }

    func test_multipleModifiers_willResolveExpectedProperties() throws {
        let source = #"""
        open class A {
          public final class B {
            private class C { }
          }
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)
        // A
        var testClass = instanceUnderTest.classes[0]
        XCTAssertEqual(testClass.name, "A")
        XCTAssertEqual(testClass.modifiers.count, 1)
        XCTAssertEqual(testClass.modifiers.first?.name, "open")
        XCTAssertNil(testClass.modifiers.first?.detail)
        // B
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "B")
        XCTAssertEqual(testClass.modifiers.count, 2)
        XCTAssertEqual(testClass.modifiers[0].name, "public")
        XCTAssertNil(testClass.modifiers[0].detail)
        XCTAssertEqual(testClass.modifiers[1].name, "final")
        XCTAssertNil(testClass.modifiers[1].detail)
        // C
        testClass = testClass.classes[0]
        XCTAssertEqual(testClass.name, "C")
        XCTAssertEqual(testClass.modifiers.count, 1)
        XCTAssertEqual(testClass.modifiers[0].name, "private")
        XCTAssertNil(testClass.modifiers[0].detail)
    }

    func test_inheritance_willResolveExpectedValues() throws {
        let source = #"""
        protocol MyThing {}
        class A: MyThing {}
        class B {}
        private class C: B, MyThing { }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 3)
        // A
        var testClass = instanceUnderTest.classes[0]
        XCTAssertEqual(testClass.name, "A")
        XCTAssertEqual(testClass.inheritance, ["MyThing"])
        // B
        testClass = instanceUnderTest.classes[1]
        XCTAssertEqual(testClass.name, "B")
        XCTAssertEqual(testClass.inheritance, [])
        // C
        testClass = instanceUnderTest.classes[2]
        XCTAssertEqual(testClass.name, "C")
        XCTAssertEqual(testClass.inheritance, ["B", "MyThing"])
    }

    func test_withGenerics_willResolveExpectedValues() throws {
        let source = #"""
        class MyClass<T: Equatable & Comparable, U> where U: Hashable {
            // class body here...
        }
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let testClass = instanceUnderTest.classes[0]

        // Check class name
        XCTAssertEqual(testClass.name, "MyClass")

        // Check generic parameters
        XCTAssertEqual(testClass.genericParameters.count, 2)
        let firstGenericParam = testClass.genericParameters[0]
        XCTAssertEqual(firstGenericParam.name, "T")
        XCTAssertEqual(firstGenericParam.type, "Equatable & Comparable") // Explicit type in this context
        let secondGenericParam = testClass.genericParameters[1]
        XCTAssertEqual(secondGenericParam.name, "U")
        XCTAssertNil(secondGenericParam.type) // No explicit type in this context

        // Check generic requirements
        XCTAssertEqual(testClass.genericRequirements.count, 1)

        let genericRequirement = testClass.genericRequirements[0]
        XCTAssertEqual(genericRequirement.leftTypeIdentifier, "U")
        XCTAssertEqual(genericRequirement.relation, .conformance)
        XCTAssertEqual(genericRequirement.rightTypeIdentifier, "Hashable")
    }

    func test_withSameTypeGenericRequirement_willResolveExpectedValues() throws {
        let source = #"""
        class MyClass<T, U> where T == U {
            // class body here...
        }
        """#

        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)

        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)

        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let myClass = instanceUnderTest.classes[0]

        // Check class name
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
        class MyClass {
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
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let classUnderTest = instanceUnderTest.classes[0]

        // Check child structures
        XCTAssertEqual(classUnderTest.structures.count, 1)
        XCTAssertEqual(classUnderTest.structures[0].name, "NestedStruct")

        // Check child classes
        XCTAssertEqual(classUnderTest.classes.count, 1)
        XCTAssertEqual(classUnderTest.classes[0].name, "NestedClass")

        // Check child enums
        XCTAssertEqual(classUnderTest.enumerations.count, 1)
        XCTAssertEqual(classUnderTest.enumerations[0].name, "NestedEnum")

        // Check child type aliases
        XCTAssertEqual(classUnderTest.typealiases.count, 1)
        XCTAssertEqual(classUnderTest.typealiases[0].name, "NestedTypeAlias")

        // Check child functions
        XCTAssertEqual(classUnderTest.functions.count, 1)
        XCTAssertEqual(classUnderTest.functions[0].identifier, "nestedFunction")

        // Check child variables
        XCTAssertEqual(classUnderTest.variables.count, 1)
        XCTAssertEqual(classUnderTest.variables[0].name, "nestedVariable")

        // Check child protocols
        XCTAssertEqual(classUnderTest.protocols.count, 1)
        XCTAssertEqual(classUnderTest.protocols[0].name, "NestedProtocol")

        // Check child subscripts
        XCTAssertEqual(classUnderTest.subscripts.count, 1)
        XCTAssertEqual(classUnderTest.subscripts[0].keyword, "subscript")

        // Check child initializers
        XCTAssertEqual(classUnderTest.initializers.count, 1)
        XCTAssertEqual(classUnderTest.initializers[0].keyword, "init")

        // Check child deinitializers
        XCTAssertEqual(classUnderTest.deinitializers.count, 1)
        XCTAssertEqual(classUnderTest.deinitializers[0].keyword, "deinit")

        // Check child operators
        XCTAssertEqual(classUnderTest.operators.count, 1)
        XCTAssertEqual(classUnderTest.operators[0].name, "+-")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        class SampleProtocol {}
        """#
        let sourceTwo = #"""
        class SampleProtocol {}
        """#
        let sourceThree = #"""
        class SampleProtocol {}
        public class SampleProtocol {}
        class OtherSampleProtocol {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let sampleOne = instanceUnderTest.classes[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 1)

        let sampleTwo = instanceUnderTest.classes[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 3)

        let sampleThree = instanceUnderTest.classes[0]
        let sampleFour = instanceUnderTest.classes[1]
        let otherSample = instanceUnderTest.classes[2]

        let equalCases: [(Class, Class)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Class, Class)] = [
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
