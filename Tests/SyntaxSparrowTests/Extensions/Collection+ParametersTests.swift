//
//  Collection+ParametersTests.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2024. All Rights Reserved.
//

import Foundation
@testable import SyntaxSparrow
import XCTest

final class CollectionParametersTests: XCTestCase {

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

    func test_emptyCollection_willReturnExpectedResults() {
        let parameters: [Parameter] = []
        XCTAssertEqual(parameters.signatureInputString(includeParenthesis: false), "")
        XCTAssertEqual(parameters.signatureInputString(includeParenthesis: true), "()")
    }

    func test_singleParameter_singleName_defaultValue_willReturnExpectedResults() {
        let source = #"""
        func example(name: String = "test") throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "name: String = \"test\""
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }

    func test_singleParameter_labelOmitted_willReturnExpectedResults() {
        let source = #"""
        func example(_ name: String) throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "_ name: String"
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }

    func test_singleParameter_labelOmitted_defaultValue_willReturnExpectedResults() {
        let source = #"""
        func example(_ name: String? = nil) throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "_ name: String? = nil"
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }

    func test_singleParameter_twoNames_defaultValue_willReturnExpectedResults() {
        let source = #"""
        func example(withName name: String = "Name") throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "withName name: String = \"Name\""
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }

    func test_multipleParams_willReturnExpectedResults() {
        let source = #"""
        func exampleWithName(_ name: String, age: Int = 0, otherThings things: String...) throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "_ name: String, age: Int = 0, otherThings things: String..."
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }

    func test_multipleParams_attributed_willReturnExpectedResults() {
        let source = #"""
        func exampleWithName(_ name: String, inout age: Int = 0, handler: @escaping (String) -> Void = {}) throws {}
        """#
        instanceUnderTest.updateToSource(source)
        instanceUnderTest.collectChildren()

        let expectedString = "_ name: String, inout age: Int = 0, handler: @escaping (String) -> Void = {}"
        let expectedParenthesisString = "(\(expectedString))"

        let function = instanceUnderTest.functions[0]
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: false), expectedString)
        XCTAssertEqual(function.signature.input.signatureInputString(includeParenthesis: true), expectedParenthesisString)
    }
}
