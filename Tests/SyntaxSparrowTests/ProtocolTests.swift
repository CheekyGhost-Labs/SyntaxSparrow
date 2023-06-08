//
//  ProtocolTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

final class ProtocolTests: XCTestCase {
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

    func test_simpleProtocol_willResolveExpectedDetails() throws {
        let source = #"""
        protocol SimpleProtocol {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.attributes.count, 0)
        XCTAssertEqual(protocolUnderTest.modifiers.count, 0)
        XCTAssertEqual(protocolUnderTest.keyword, "protocol")
        XCTAssertEqual(protocolUnderTest.name, "SimpleProtocol")
        XCTAssertEqual(protocolUnderTest.associatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.inheritance.count, 0)
        XCTAssertEqual(protocolUnderTest.genericRequirements.count, 0)
        XCTAssertSourceStartPositionEquals(protocolUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(protocolUnderTest.sourceLocation, (0, 26, 26))
        XCTAssertEqual(protocolUnderTest.extractFromSource(source), "protocol SimpleProtocol {}")
        XCTAssertEqual(protocolUnderTest.description, "protocol SimpleProtocol {}")
    }

    func test_withAttributes() throws {
        let source = #"""
        @available(iOS 15, *)
        protocol AttributedProtocol {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.attributes.count, 1)
        XCTAssertEqual(protocolUnderTest.attributes[0].name, "available")
        XCTAssertAttributesArgumentsEqual(protocolUnderTest.attributes[0], [
            (nil, "iOS 15"),
            (nil, "*"),
        ])
        XCTAssertEqual(protocolUnderTest.modifiers.count, 0)
        XCTAssertEqual(protocolUnderTest.keyword, "protocol")
        XCTAssertEqual(protocolUnderTest.name, "AttributedProtocol")
        XCTAssertEqual(protocolUnderTest.associatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.inheritance.count, 0)
        XCTAssertEqual(protocolUnderTest.genericRequirements.count, 0)
        XCTAssertSourceStartPositionEquals(protocolUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(protocolUnderTest.sourceLocation, (1, 30, 52))
        XCTAssertEqual(protocolUnderTest.extractFromSource(source), "@available(iOS 15, *)\nprotocol AttributedProtocol {}")
        XCTAssertEqual(protocolUnderTest.description, "@available(iOS 15, *)\nprotocol AttributedProtocol {}")
    }

    func test_withModifiers() throws {
        let source = #"""
        public protocol ModifiedProtocol {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.attributes.count, 0)
        XCTAssertEqual(protocolUnderTest.modifiers.count, 1)
        XCTAssertEqual(protocolUnderTest.modifiers[0].name, "public")
        XCTAssertEqual(protocolUnderTest.keyword, "protocol")
        XCTAssertEqual(protocolUnderTest.name, "ModifiedProtocol")
        XCTAssertEqual(protocolUnderTest.associatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes.count, 0)
        XCTAssertEqual(protocolUnderTest.inheritance.count, 0)
        XCTAssertEqual(protocolUnderTest.genericRequirements.count, 0)
        XCTAssertSourceStartPositionEquals(protocolUnderTest.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(protocolUnderTest.sourceLocation, (0, 35, 35))
        XCTAssertEqual(protocolUnderTest.extractFromSource(source), "public protocol ModifiedProtocol {}")
        XCTAssertEqual(protocolUnderTest.description, "public protocol ModifiedProtocol {}")
    }

    func test_withAssociatedTypes_willResolveExpectedDetails() throws {
        let source = #"""
        protocol AssociatedTypeProtocol {
            associatedtype A
            associatedtype B: Equatable
        }
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.associatedTypes.count, 2)
        XCTAssertEqual(protocolUnderTest.associatedTypes[0].name, "A")
        XCTAssertEqual(protocolUnderTest.associatedTypes[0].inheritance, [])
        XCTAssertEqual(protocolUnderTest.associatedTypes[1].name, "B")
        XCTAssertEqual(protocolUnderTest.associatedTypes[1].inheritance, ["Equatable"])
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes.count, 0)
    }

    func test_withPrimaryAssociatedTypes_willResolveExpectedDetails() throws {
        let source = #"""
        protocol PrimaryAssociatedTypeProtocol<T, U> {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes.count, 2)
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes[0], "T")
        XCTAssertEqual(protocolUnderTest.primaryAssociatedTypes[1], "U")
    }

    func test_withInheritance_willResolveExpectedDetails() throws {
        let source = #"""
        protocol A {}
        protocol B {}
        protocol InheritanceProtocol: A, B {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 3)

        let protocolUnderTest = instanceUnderTest.protocols[2]
        XCTAssertEqual(protocolUnderTest.inheritance.count, 2)
        XCTAssertEqual(protocolUnderTest.inheritance[0], "A")
        XCTAssertEqual(protocolUnderTest.inheritance[1], "B")
    }

    func test_withGenericRequirements_willResolveExpectedDetails() throws {
        let source = #"""
        protocol GenericRequirementProtocol<T> where T: Hashable {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let protocolUnderTest = instanceUnderTest.protocols[0]
        XCTAssertEqual(protocolUnderTest.genericRequirements.count, 1)
        XCTAssertEqual(protocolUnderTest.genericRequirements[0].leftTypeIdentifier, "T")
        XCTAssertEqual(protocolUnderTest.genericRequirements[0].rightTypeIdentifier, "Hashable")
        XCTAssertEqual(protocolUnderTest.genericRequirements[0].relation, .conformance)
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        protocol SampleProtocol {}
        """#
        let sourceTwo = #"""
        protocol SampleProtocol {}
        """#
        let sourceThree = #"""
        protocol SampleProtocol {}
        public protocol SampleProtocol {}
        protocol OtherSampleProtocol {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let sampleOne = instanceUnderTest.protocols[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 1)

        let sampleTwo = instanceUnderTest.protocols[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 3)

        let sampleThree = instanceUnderTest.protocols[0]
        let sampleFour = instanceUnderTest.protocols[1]
        let otherSample = instanceUnderTest.protocols[2]

        typealias ProtocolDeclaration = Declaration & Equatable

        let equalCases: [(ProtocolDecl, ProtocolDecl)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree),
        ]
        let notEqualCases: [(ProtocolDecl, ProtocolDecl)] = [
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
