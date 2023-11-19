//
//  StructureTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class TypealiasTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    override func tearDownWithError() throws {
        instanceUnderTest = nil
    }

    // MARK: - Tests

    func test_typealiasDeclaration_willResolveExpectedDetails() throws {
        let source = #"""
        typealias MyString = String
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let typealiasDecl = instanceUnderTest.typealiases[0]
        XCTAssertEqual(typealiasDecl.attributes.count, 0)
        XCTAssertEqual(typealiasDecl.modifiers.count, 0)
        XCTAssertEqual(typealiasDecl.keyword, "typealias")
        XCTAssertEqual(typealiasDecl.name, "MyString")
        XCTAssertEqual(typealiasDecl.initializedType, .simple("String"))
        XCTAssertEqual(typealiasDecl.genericParameters.count, 0)
        XCTAssertEqual(typealiasDecl.genericRequirements.count, 0)
        AssertSourceDetailsEquals(
            getSourceLocation(for: typealiasDecl, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 27, 27),
            source: "typealias MyString = String"
        )
        XCTAssertEqual(typealiasDecl.description, "typealias MyString = String")
    }

    func test_typealiasWithGenericParameters_willResolveExpectedDetails() throws {
        let source = #"""
        typealias EquatableArray<T: Equatable> = Array<T>
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let typealiasDecl = instanceUnderTest.typealiases[0]
        XCTAssertEqual(typealiasDecl.attributes.count, 0)
        XCTAssertEqual(typealiasDecl.modifiers.count, 0)
        XCTAssertEqual(typealiasDecl.keyword, "typealias")
        XCTAssertEqual(typealiasDecl.name, "EquatableArray")
        XCTAssertEqual(typealiasDecl.genericParameters.count, 1)
        XCTAssertEqual(typealiasDecl.genericParameters[0].name, "T")
        XCTAssertEqual(typealiasDecl.genericParameters[0].type, "Equatable")
        XCTAssertEqual(typealiasDecl.genericRequirements.count, 0)
        if case let EntityType.array(array) = typealiasDecl.initializedType {
            XCTAssertEqual(array.declType, .generic)
            XCTAssertFalse(array.isOptional)
            XCTAssertEqual(array.elementType, .simple("T"))
        } else {
            XCTFail("function.signature.input[0] type should be Array")
        }

        AssertSourceDetailsEquals(
            getSourceLocation(for: typealiasDecl, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 49, 49),
            source: "typealias EquatableArray<T: Equatable> = Array<T>"
        )
        XCTAssertEqual(typealiasDecl.description, "typealias EquatableArray<T: Equatable> = Array<T>")
    }

    func test_typealiasWithNoInitializedType_willResolveExpectedDetails() throws {
        let source = #"""
        typealias MyCustomType
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let typealiasDecl = instanceUnderTest.typealiases[0]
        XCTAssertEqual(typealiasDecl.attributes.count, 0)
        XCTAssertEqual(typealiasDecl.modifiers.count, 0)
        XCTAssertEqual(typealiasDecl.keyword, "typealias")
        XCTAssertEqual(typealiasDecl.name, "MyCustomType")
        XCTAssertEqual(typealiasDecl.initializedType, .empty)
        XCTAssertEqual(typealiasDecl.genericParameters.count, 0)
        XCTAssertEqual(typealiasDecl.genericRequirements.count, 0)
        AssertSourceDetailsEquals(
            getSourceLocation(for: typealiasDecl, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 22, 22),
            source: "typealias MyCustomType"
        )
        XCTAssertEqual(typealiasDecl.description, "typealias MyCustomType")
    }

    func test_typealiasWithAttribute_willResolveExpectedDetails() throws {
        let source = #"""
        @available(iOS 15, *)
        typealias MyCustomType = Int
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let typealiasDecl = instanceUnderTest.typealiases[0]
        XCTAssertEqual(typealiasDecl.attributes.count, 1)
        XCTAssertEqual(typealiasDecl.attributes[0].name, "available")
        XCTAssertEqual(typealiasDecl.modifiers.count, 0)
        XCTAssertEqual(typealiasDecl.keyword, "typealias")
        XCTAssertEqual(typealiasDecl.name, "MyCustomType")
        XCTAssertEqual(typealiasDecl.initializedType, .simple("Int"))
        XCTAssertEqual(typealiasDecl.genericParameters.count, 0)
        XCTAssertEqual(typealiasDecl.genericRequirements.count, 0)
        AssertSourceDetailsEquals(
            getSourceLocation(for: typealiasDecl, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (1, 28, 50),
            source: "@available(iOS 15, *)\ntypealias MyCustomType = Int"
        )
        XCTAssertEqual(typealiasDecl.description, "@available(iOS 15, *)\ntypealias MyCustomType = Int")
    }

    func test_typealiasWithModifier_willResolveExpectedDetails() throws {
        let source = #"""
        public typealias MyCustomType = Int?
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let typealiasDecl = instanceUnderTest.typealiases[0]
        XCTAssertEqual(typealiasDecl.attributes.count, 0)
        XCTAssertEqual(typealiasDecl.modifiers.count, 1)
        XCTAssertEqual(typealiasDecl.modifiers[0].name, "public")
        XCTAssertEqual(typealiasDecl.keyword, "typealias")
        XCTAssertEqual(typealiasDecl.name, "MyCustomType")
        XCTAssertEqual(typealiasDecl.initializedType, .simple("Int?"))
        XCTAssertEqual(typealiasDecl.genericParameters.count, 0)
        XCTAssertEqual(typealiasDecl.genericRequirements.count, 0)
        AssertSourceDetailsEquals(
            getSourceLocation(for: typealiasDecl, from: instanceUnderTest),
            start: (0, 0, 0),
            end: (0, 36, 36),
            source: "public typealias MyCustomType = Int?"
        )
        XCTAssertEqual(typealiasDecl.description, "public typealias MyCustomType = Int?")
    }

    func test_typealias_initializedTypeIsOptional_willResolveExpectedValues() {
        let source = #"""
        typealias MyAlias = String
        typealias MyAlias = String?
        typealias MyAlias = (() -> Void)
        typealias MyAlias = (() -> Void)?
        typealias MyAlias = (name: String, age: Int?)
        typealias MyAlias = (name: String, age: Int?)?
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 6)
        XCTAssertFalse(instanceUnderTest.typealiases[0].initializedTypeIsOptional)
        XCTAssertTrue(instanceUnderTest.typealiases[1].initializedTypeIsOptional)
        XCTAssertFalse(instanceUnderTest.typealiases[2].initializedTypeIsOptional)
        XCTAssertTrue(instanceUnderTest.typealiases[3].initializedTypeIsOptional)
        XCTAssertFalse(instanceUnderTest.typealiases[4].initializedTypeIsOptional)
        XCTAssertTrue(instanceUnderTest.typealiases[5].initializedTypeIsOptional)
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        typealias MyCustomType = Int
        """#
        let sourceTwo = #"""
        typealias MyCustomType = Int
        """#
        let sourceThree = #"""
        typealias MyCustomType = Int
        public typealias MyCustomType = Int
        typealias OtherMyCustomType = Int
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let sampleOne = instanceUnderTest.typealiases[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 1)

        let sampleTwo = instanceUnderTest.typealiases[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 3)

        let sampleThree = instanceUnderTest.typealiases[0]
        let sampleFour = instanceUnderTest.typealiases[1]
        let otherSample = instanceUnderTest.typealiases[2]

        let equalCases: [(Typealias, Typealias)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(Typealias, Typealias)] = [
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
