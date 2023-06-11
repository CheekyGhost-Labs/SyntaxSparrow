//
//  ImportTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import SyntaxSparrow
import XCTest

final class ImportTests: XCTestCase {
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

    func test_standardImports_willResolveExpectedDetails() throws {
        let source = #"""
        import Foundation
        import SyntaxSparrow
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 2)

        let foundationImport = instanceUnderTest.imports[0]
        XCTAssertEqual(foundationImport.attributes.count, 0)
        XCTAssertEqual(foundationImport.modifiers.count, 0)
        XCTAssertEqual(foundationImport.keyword, "import")
        XCTAssertNil(foundationImport.kind)
        XCTAssertEqual(foundationImport.pathComponents, ["Foundation"])
        XCTAssertSourceStartPositionEquals(foundationImport.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(foundationImport.sourceLocation, (0, 17, 17))
        XCTAssertEqual(foundationImport.extractFromSource(source), "import Foundation")
        XCTAssertEqual(foundationImport.description, "import Foundation")

        let sparrowImport = instanceUnderTest.imports[1]
        XCTAssertEqual(sparrowImport.attributes.count, 0)
        XCTAssertEqual(sparrowImport.modifiers.count, 0)
        XCTAssertEqual(sparrowImport.keyword, "import")
        XCTAssertNil(sparrowImport.kind)
        XCTAssertEqual(sparrowImport.pathComponents, ["SyntaxSparrow"])
        XCTAssertSourceStartPositionEquals(sparrowImport.sourceLocation, (1, 0, 18))
        XCTAssertSourceEndPositionEquals(sparrowImport.sourceLocation, (1, 20, 38))
        XCTAssertEqual(sparrowImport.extractFromSource(source), "import SyntaxSparrow")
        XCTAssertEqual(sparrowImport.description, "import SyntaxSparrow")
    }

    func test_importWithKind_willResolveExpectedDetails() throws {
        let source = #"""
        import struct SyntaxSparrow.Class
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 1)

        let foundationImport = instanceUnderTest.imports[0]
        XCTAssertEqual(foundationImport.attributes.count, 0)
        XCTAssertEqual(foundationImport.modifiers.count, 0)
        XCTAssertEqual(foundationImport.keyword, "import")
        XCTAssertEqual(foundationImport.kind, "struct")
        XCTAssertEqual(foundationImport.pathComponents, ["SyntaxSparrow", "Class"])
        XCTAssertSourceStartPositionEquals(foundationImport.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(foundationImport.sourceLocation, (0, 33, 33))
        XCTAssertEqual(foundationImport.extractFromSource(source), "import struct SyntaxSparrow.Class")
        XCTAssertEqual(foundationImport.description, "import struct SyntaxSparrow.Class")
    }

    func test_importWithAttribute_willResolveExpectedDetails() throws {
        let source = #"""
        @available(iOS 15, *)
        import Foundation
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 1)

        let foundationImport = instanceUnderTest.imports[0]
        XCTAssertEqual(foundationImport.attributes.count, 1)
        XCTAssertEqual(foundationImport.attributes.first?.name, "available")
        XCTAssertEqual(foundationImport.modifiers.count, 0)
        XCTAssertEqual(foundationImport.keyword, "import")
        XCTAssertNil(foundationImport.kind)
        XCTAssertEqual(foundationImport.pathComponents, ["Foundation"])
        XCTAssertSourceStartPositionEquals(foundationImport.sourceLocation, (0, 0, 0))
        XCTAssertSourceEndPositionEquals(foundationImport.sourceLocation, (1, 17, 39))
        XCTAssertEqual(foundationImport.extractFromSource(source), "@available(iOS 15, *)\nimport Foundation")
        XCTAssertEqual(foundationImport.description, "@available(iOS 15, *)\nimport Foundation")
    }

    func test_hashable_equatable_willReturnExpectedResults() throws {
        let source = #"""
        @available(iOS 15, *)
        import Foundation
        """#
        let sourceTwo = #"""
        @available(iOS 15, *)
        import Foundation
        """#
        let sourceThree = #"""
        @available(iOS 15, *)
        import Foundation
        import Foundation
        import OtherImport
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 1)

        let sampleOne = instanceUnderTest.imports[0]

        instanceUnderTest.updateToSource(sourceTwo)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 1)

        let sampleTwo = instanceUnderTest.imports[0]

        instanceUnderTest.updateToSource(sourceThree)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.imports.count, 3)

        let sampleThree = instanceUnderTest.imports[0]
        let sampleFour = instanceUnderTest.imports[1]
        let otherSample = instanceUnderTest.imports[2]

        let equalCases: [(Import, Import)] = [
            (sampleOne, sampleTwo),
            (sampleOne, sampleThree),
            (sampleTwo, sampleThree)
        ]
        let notEqualCases: [(Import, Import)] = [
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
