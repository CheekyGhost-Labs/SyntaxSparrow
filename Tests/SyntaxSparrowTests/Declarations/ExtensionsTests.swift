//
//  ClassTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ExtensionTests: XCTestCase {
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

    func test_extension_children_willResolveExpectedChildDeclarations() throws {
        let source = #"""
        extension String {
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
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)
        // A
        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.extendedType, "String")
        XCTAssertEqual(extensionUnderTest.keyword, "extension")
        XCTAssertEqual(extensionUnderTest.modifiers.count, 0)
        XCTAssertEqual(extensionUnderTest.attributes.count, 0)
        AssertSourceDetailsEquals(
            getSourceLocation(for: extensionUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (12, 1, 413),
            source: source
        )
        // Children
        XCTAssertEqual(extensionUnderTest.structures.count, 1)
        XCTAssertEqual(extensionUnderTest.structures[0].name, "NestedStruct")
        XCTAssertEqual(extensionUnderTest.classes.count, 1)
        XCTAssertEqual(extensionUnderTest.classes[0].name, "NestedClass")
        XCTAssertEqual(extensionUnderTest.enumerations.count, 1)
        XCTAssertEqual(extensionUnderTest.enumerations[0].name, "NestedEnum")
        XCTAssertEqual(extensionUnderTest.typealiases.count, 1)
        XCTAssertEqual(extensionUnderTest.typealiases[0].name, "NestedTypeAlias")
        XCTAssertEqual(extensionUnderTest.functions.count, 1)
        XCTAssertEqual(extensionUnderTest.functions[0].identifier, "nestedFunction")
        XCTAssertEqual(extensionUnderTest.variables.count, 1)
        XCTAssertEqual(extensionUnderTest.variables[0].name, "nestedVariable")
        XCTAssertEqual(extensionUnderTest.protocols.count, 1)
        XCTAssertEqual(extensionUnderTest.protocols[0].name, "NestedProtocol")
        XCTAssertEqual(extensionUnderTest.subscripts.count, 1)
        XCTAssertEqual(extensionUnderTest.subscripts[0].keyword, "subscript")
        XCTAssertEqual(extensionUnderTest.initializers.count, 1)
        XCTAssertEqual(extensionUnderTest.initializers[0].keyword, "init")
        XCTAssertEqual(extensionUnderTest.deinitializers.count, 1)
        XCTAssertEqual(extensionUnderTest.deinitializers[0].keyword, "deinit")
        XCTAssertEqual(extensionUnderTest.operators.count, 1)
        XCTAssertEqual(extensionUnderTest.operators[0].name, "+-")
    }


    func test_extension_withAttributes_willResolveExpectedValues() throws {
        let source = #"""
        @available(iOS 15, *)
        extension String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.attributes.count, 1)
        XCTAssertEqual(extensionUnderTest.attributes[0].name, "available")
        XCTAssertAttributesArgumentsEqual(extensionUnderTest.attributes[0], [
            (nil, "iOS 15"),
            (nil, "*")
        ])
        XCTAssertEqual(extensionUnderTest.attributes[0].description, "@available(iOS 15, *)")
        AssertSourceDetailsEquals(
            getSourceLocation(for: extensionUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 19, 41),
            source: "@available(iOS 15, *)\nextension String {}"
        )
    }

    func test_extension_withModifiers_willResolveExpectedValues() throws {
        let source = #"""
        public extension String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.modifiers.count, 1)
        XCTAssertEqual(extensionUnderTest.modifiers[0].name, "public")
        AssertSourceDetailsEquals(
            getSourceLocation(for: extensionUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 26, 26),
            source: "public extension String {}"
        )
    }

    func test_extension_withInheritance_willResolveExpectedValues() throws {
        let source = #"""
        protocol A {}
        protocol B {}
        extension String: A, B {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.inheritance.count, 2)
        XCTAssertEqual(extensionUnderTest.inheritance[0], "A")
        XCTAssertEqual(extensionUnderTest.inheritance[1], "B")
    }

    func test_extension_withGenericRequirements_willResolveExpectedValues() throws {
        let source = #"""
        extension Array where Element: Comparable {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let extensionUnderTest = instanceUnderTest.extensions[0]
        XCTAssertEqual(extensionUnderTest.genericRequirements.count, 1)
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].relation, .conformance)
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].leftTypeIdentifier, "Element")
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].rightTypeIdentifier, "Comparable")
        XCTAssertEqual(extensionUnderTest.genericRequirements[0].description, "Element: Comparable")
        AssertSourceDetailsEquals(
            getSourceLocation(for: extensionUnderTest, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 44, 44),
            source: "extension Array where Element: Comparable {}"
        )
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        extension String {}
        """#
        let sourceTwo = #"""
        extension String {}
        """#
        let sourceThree = #"""
        extension String {}
        public extension String {}
        extension CustomType {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let sampleOne = instanceUnderTest.extensions[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 1)

        let sampleTwo = instanceUnderTest.extensions[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 3)

        let sampleThree = instanceUnderTest.extensions[0]
        let sampleFour = instanceUnderTest.extensions[1]
        let otherSample = instanceUnderTest.extensions[2]

        let equalCases: [(Extension, Extension)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(Extension, Extension)] = [
            (sampleOne, sampleFour),
            (sampleOne, otherSample),
            (sampleTwo, sampleFour),
            (sampleTwo, otherSample),
            (sampleThree, sampleFour),
            (sampleThree, otherSample)
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
