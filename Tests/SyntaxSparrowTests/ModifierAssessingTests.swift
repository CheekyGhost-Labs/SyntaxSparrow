//
//  ModifierAssessingTests.swift
//  
//
//  Created by Michael O'Brien on 10/5/2024.
//

import XCTest
@testable import SyntaxSparrow

final class ModifierAssessingTests: XCTestCase {
    // MARK: - Properties

    var instanceUnderTest: SyntaxTree!

    // MARK: - Lifecycle

    override func setUpWithError() throws {
        instanceUnderTest = SyntaxTree(viewMode: .sourceAccurate, sourceBuffer: "")
    }

    // MARK: - Tests

    func test_modifierAssessing_class_willResolveExpectedValues() {
        let source = #"""
        class Example {}
        public class Example {}
        private class Example {}
        open class Example {}
        final class Example {}
        public final class Example {}
        fileprivate class Example {}
        fileprivate final class Example {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.classes.count, 8)
        // Internal
        XCTAssertTrue(instanceUnderTest.classes[0].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[0].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[0].isOpen)
        XCTAssertFalse(instanceUnderTest.classes[0].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.classes[1].isInternal)
        XCTAssertTrue(instanceUnderTest.classes[1].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[1].isOpen)
        XCTAssertFalse(instanceUnderTest.classes[1].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.classes[2].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[2].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[2].isOpen)
        XCTAssertFalse(instanceUnderTest.classes[2].isFinal)
        XCTAssertTrue(instanceUnderTest.classes[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[2].isFilePrivate)
        // Open
        XCTAssertFalse(instanceUnderTest.classes[3].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[3].isPublic)
        XCTAssertTrue(instanceUnderTest.classes[3].isOpen)
        XCTAssertFalse(instanceUnderTest.classes[3].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[3].isFilePrivate)
        // Final
        XCTAssertTrue(instanceUnderTest.classes[4].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[4].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[4].isOpen)
        XCTAssertTrue(instanceUnderTest.classes[4].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[4].isFilePrivate)
        // Public Final
        XCTAssertFalse(instanceUnderTest.classes[5].isInternal)
        XCTAssertTrue(instanceUnderTest.classes[5].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[5].isOpen)
        XCTAssertTrue(instanceUnderTest.classes[5].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.classes[5].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.classes[6].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[6].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[6].isOpen)
        XCTAssertFalse(instanceUnderTest.classes[6].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.classes[6].isFilePrivate)
        // fileprivate final
        XCTAssertFalse(instanceUnderTest.classes[7].isInternal)
        XCTAssertFalse(instanceUnderTest.classes[7].isPublic)
        XCTAssertFalse(instanceUnderTest.classes[7].isOpen)
        XCTAssertTrue(instanceUnderTest.classes[7].isFinal)
        XCTAssertFalse(instanceUnderTest.classes[7].isPrivate)
        XCTAssertTrue(instanceUnderTest.classes[7].isFilePrivate)
    }

    func test_modifierAssessing_functions_willResolveExpectedValues() {
        let source = #"""
        func example() {}
        public func example() {}
        private func example() {}
        open func example() {}
        final func example() {}
        public final func example() {}
        fileprivate func example() {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.functions.count, 7)
        // Internal
        XCTAssertTrue(instanceUnderTest.functions[0].isInternal)
        XCTAssertFalse(instanceUnderTest.functions[0].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[0].isOpen)
        XCTAssertFalse(instanceUnderTest.functions[0].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.functions[1].isInternal)
        XCTAssertTrue(instanceUnderTest.functions[1].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[1].isOpen)
        XCTAssertFalse(instanceUnderTest.functions[1].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.functions[2].isInternal)
        XCTAssertFalse(instanceUnderTest.functions[2].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[2].isOpen)
        XCTAssertFalse(instanceUnderTest.functions[2].isFinal)
        XCTAssertTrue(instanceUnderTest.functions[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[2].isFilePrivate)
        // Open
        XCTAssertFalse(instanceUnderTest.functions[3].isInternal)
        XCTAssertFalse(instanceUnderTest.functions[3].isPublic)
        XCTAssertTrue(instanceUnderTest.functions[3].isOpen)
        XCTAssertFalse(instanceUnderTest.functions[3].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[3].isFilePrivate)
        // Final
        XCTAssertTrue(instanceUnderTest.functions[4].isInternal)
        XCTAssertFalse(instanceUnderTest.functions[4].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[4].isOpen)
        XCTAssertTrue(instanceUnderTest.functions[4].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[4].isFilePrivate)
        // Public Final
        XCTAssertFalse(instanceUnderTest.functions[5].isInternal)
        XCTAssertTrue(instanceUnderTest.functions[5].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[5].isOpen)
        XCTAssertTrue(instanceUnderTest.functions[5].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.functions[5].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.functions[6].isInternal)
        XCTAssertFalse(instanceUnderTest.functions[6].isPublic)
        XCTAssertFalse(instanceUnderTest.functions[6].isOpen)
        XCTAssertFalse(instanceUnderTest.functions[6].isFinal)
        XCTAssertFalse(instanceUnderTest.functions[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.functions[6].isFilePrivate)
    }

    func test_modifierAssessing_variable_willResolveExpectedValues() {
        let source = #"""
        var name: String = ""
        public var name: String = ""
        private var name: String = ""
        open var name: String = ""
        final var name: String = ""
        public final var name: String = ""
        private(set) public var name: String = ""
        private(set) var name: String = ""
        fileprivate var name: String = ""
        fileprivate(set) var name: String = ""
        fileprivate(set) public var name: String = ""
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.variables.count, 11)
        // Internal
        XCTAssertTrue(instanceUnderTest.variables[0].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[0].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[0].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[0].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[0].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[0].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[0].isFilePrivateSetter)
        // Public
        XCTAssertFalse(instanceUnderTest.variables[1].isInternal)
        XCTAssertTrue(instanceUnderTest.variables[1].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[1].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[1].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[1].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[1].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[1].isFilePrivateSetter)
        // Private
        XCTAssertFalse(instanceUnderTest.variables[2].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[2].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[2].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[2].isFinal)
        XCTAssertTrue(instanceUnderTest.variables[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[2].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[2].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[2].isFilePrivateSetter)
        // Open
        XCTAssertFalse(instanceUnderTest.variables[3].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[3].isPublic)
        XCTAssertTrue(instanceUnderTest.variables[3].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[3].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[3].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[3].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[3].isFilePrivateSetter)
        // Final
        XCTAssertTrue(instanceUnderTest.variables[4].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[4].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[4].isOpen)
        XCTAssertTrue(instanceUnderTest.variables[4].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[4].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[4].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[4].isFilePrivateSetter)
        // Public Final
        XCTAssertFalse(instanceUnderTest.variables[5].isInternal)
        XCTAssertTrue(instanceUnderTest.variables[5].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[5].isOpen)
        XCTAssertTrue(instanceUnderTest.variables[5].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[5].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[5].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[5].isFilePrivateSetter)
        // Private setter public
        XCTAssertFalse(instanceUnderTest.variables[6].isInternal)
        XCTAssertTrue(instanceUnderTest.variables[6].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[6].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[6].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.variables[6].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[6].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[6].isFilePrivateSetter)
        // Private setter internal
        XCTAssertTrue(instanceUnderTest.variables[7].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[7].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[7].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[7].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[7].isPrivate)
        XCTAssertTrue(instanceUnderTest.variables[7].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[7].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[7].isFilePrivateSetter)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.variables[8].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[8].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[8].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[8].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[8].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[8].isPrivateSetter)
        XCTAssertTrue(instanceUnderTest.variables[8].isFilePrivate)
        XCTAssertFalse(instanceUnderTest.variables[8].isFilePrivateSetter)
        // fileprivate setter internal
        XCTAssertTrue(instanceUnderTest.variables[9].isInternal)
        XCTAssertFalse(instanceUnderTest.variables[9].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[9].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[9].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[9].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[9].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[9].isFilePrivate)
        XCTAssertTrue(instanceUnderTest.variables[9].isFilePrivateSetter)
        // fileprivate setter public
        XCTAssertFalse(instanceUnderTest.variables[10].isInternal)
        XCTAssertTrue(instanceUnderTest.variables[10].isPublic)
        XCTAssertFalse(instanceUnderTest.variables[10].isOpen)
        XCTAssertFalse(instanceUnderTest.variables[10].isFinal)
        XCTAssertFalse(instanceUnderTest.variables[10].isPrivate)
        XCTAssertFalse(instanceUnderTest.variables[10].isPrivateSetter)
        XCTAssertFalse(instanceUnderTest.variables[10].isFilePrivate)
        XCTAssertTrue(instanceUnderTest.variables[10].isFilePrivateSetter)
    }

    func test_modifierAssessing_structs_willResolveExpectedValues() {
        let source = #"""
        struct Example {}
        public struct Example {}
        private struct Example {}
        fileprivate struct Example {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.structures.count, 4)
        // Internal
        XCTAssertTrue(instanceUnderTest.structures[0].isInternal)
        XCTAssertFalse(instanceUnderTest.structures[0].isPublic)
        XCTAssertFalse(instanceUnderTest.structures[0].isOpen)
        XCTAssertFalse(instanceUnderTest.structures[0].isFinal)
        XCTAssertFalse(instanceUnderTest.structures[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.structures[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.structures[1].isInternal)
        XCTAssertTrue(instanceUnderTest.structures[1].isPublic)
        XCTAssertFalse(instanceUnderTest.structures[1].isOpen)
        XCTAssertFalse(instanceUnderTest.structures[1].isFinal)
        XCTAssertFalse(instanceUnderTest.structures[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.structures[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.structures[2].isInternal)
        XCTAssertFalse(instanceUnderTest.structures[2].isPublic)
        XCTAssertFalse(instanceUnderTest.structures[2].isOpen)
        XCTAssertFalse(instanceUnderTest.structures[2].isFinal)
        XCTAssertTrue(instanceUnderTest.structures[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.structures[2].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.structures[3].isInternal)
        XCTAssertFalse(instanceUnderTest.structures[3].isPublic)
        XCTAssertFalse(instanceUnderTest.structures[3].isOpen)
        XCTAssertFalse(instanceUnderTest.structures[3].isFinal)
        XCTAssertFalse(instanceUnderTest.structures[3].isPrivate)
        XCTAssertTrue(instanceUnderTest.structures[3].isFilePrivate)
        // Note: While technically parsable by SwiftSyntax - structures can't be open or final - not explicitly testing this
    }

    func test_modifierAssessing_enums_willResolveExpectedValues() {
        let source = #"""
        enum Example {}
        public enum Example {}
        private enum Example {}
        fileprivate enum Example {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.enumerations.count, 4)
        // Internal
        XCTAssertTrue(instanceUnderTest.enumerations[0].isInternal)
        XCTAssertFalse(instanceUnderTest.enumerations[0].isPublic)
        XCTAssertFalse(instanceUnderTest.enumerations[0].isOpen)
        XCTAssertFalse(instanceUnderTest.enumerations[0].isFinal)
        XCTAssertFalse(instanceUnderTest.enumerations[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.enumerations[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.enumerations[1].isInternal)
        XCTAssertTrue(instanceUnderTest.enumerations[1].isPublic)
        XCTAssertFalse(instanceUnderTest.enumerations[1].isOpen)
        XCTAssertFalse(instanceUnderTest.enumerations[1].isFinal)
        XCTAssertFalse(instanceUnderTest.enumerations[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.enumerations[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.enumerations[2].isInternal)
        XCTAssertFalse(instanceUnderTest.enumerations[2].isPublic)
        XCTAssertFalse(instanceUnderTest.enumerations[2].isOpen)
        XCTAssertFalse(instanceUnderTest.enumerations[2].isFinal)
        XCTAssertTrue(instanceUnderTest.enumerations[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.enumerations[2].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.enumerations[3].isInternal)
        XCTAssertFalse(instanceUnderTest.enumerations[3].isPublic)
        XCTAssertFalse(instanceUnderTest.enumerations[3].isOpen)
        XCTAssertFalse(instanceUnderTest.enumerations[3].isFinal)
        XCTAssertFalse(instanceUnderTest.enumerations[3].isPrivate)
        XCTAssertTrue(instanceUnderTest.enumerations[3].isFilePrivate)
        // Note: While technically parsable by SwiftSyntax - enums can't be open or final - not explicitly testing this
    }

    func test_modifierAssessing_extensions_willResolveExpectedValues() {
        let source = #"""
        extension String {}
        public extension String {}
        private extension String {}
        fileprivate extension String {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.extensions.count, 4)
        // Internal
        XCTAssertTrue(instanceUnderTest.extensions[0].isInternal)
        XCTAssertFalse(instanceUnderTest.extensions[0].isPublic)
        XCTAssertFalse(instanceUnderTest.extensions[0].isOpen)
        XCTAssertFalse(instanceUnderTest.extensions[0].isFinal)
        XCTAssertFalse(instanceUnderTest.extensions[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.extensions[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.extensions[1].isInternal)
        XCTAssertTrue(instanceUnderTest.extensions[1].isPublic)
        XCTAssertFalse(instanceUnderTest.extensions[1].isOpen)
        XCTAssertFalse(instanceUnderTest.extensions[1].isFinal)
        XCTAssertFalse(instanceUnderTest.extensions[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.extensions[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.extensions[2].isInternal)
        XCTAssertFalse(instanceUnderTest.extensions[2].isPublic)
        XCTAssertFalse(instanceUnderTest.extensions[2].isOpen)
        XCTAssertFalse(instanceUnderTest.extensions[2].isFinal)
        XCTAssertTrue(instanceUnderTest.extensions[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.extensions[2].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.extensions[3].isInternal)
        XCTAssertFalse(instanceUnderTest.extensions[3].isPublic)
        XCTAssertFalse(instanceUnderTest.extensions[3].isOpen)
        XCTAssertFalse(instanceUnderTest.extensions[3].isFinal)
        XCTAssertFalse(instanceUnderTest.extensions[3].isPrivate)
        XCTAssertTrue(instanceUnderTest.extensions[3].isFilePrivate)
        // Note: While technically parsable by SwiftSyntax - extensions can't be open or final - not explicitly testing this
    }

    func test_modifierAssessing_actor_willResolveExpectedValues() {
        let source = #"""
        actor Example {}
        public actor Example {}
        private actor Example {}
        final actor Example {}
        public final actor Example {}
        private final actor Example {}
        fileprivate actor Example {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.actors.count, 7)
        // Internal
        XCTAssertTrue(instanceUnderTest.actors[0].isInternal)
        XCTAssertFalse(instanceUnderTest.actors[0].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[0].isOpen)
        XCTAssertFalse(instanceUnderTest.actors[0].isFinal)
        XCTAssertFalse(instanceUnderTest.actors[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.actors[1].isInternal)
        XCTAssertTrue(instanceUnderTest.actors[1].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[1].isOpen)
        XCTAssertFalse(instanceUnderTest.actors[1].isFinal)
        XCTAssertFalse(instanceUnderTest.actors[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.actors[2].isInternal)
        XCTAssertFalse(instanceUnderTest.actors[2].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[2].isOpen)
        XCTAssertFalse(instanceUnderTest.actors[2].isFinal)
        XCTAssertTrue(instanceUnderTest.actors[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[2].isFilePrivate)
        // Final internal
        XCTAssertTrue(instanceUnderTest.actors[3].isInternal)
        XCTAssertFalse(instanceUnderTest.actors[3].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[3].isOpen)
        XCTAssertTrue(instanceUnderTest.actors[3].isFinal)
        XCTAssertFalse(instanceUnderTest.actors[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[3].isFilePrivate)
        // Final public
        XCTAssertFalse(instanceUnderTest.actors[4].isInternal)
        XCTAssertTrue(instanceUnderTest.actors[4].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[4].isOpen)
        XCTAssertTrue(instanceUnderTest.actors[4].isFinal)
        XCTAssertFalse(instanceUnderTest.actors[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[4].isFilePrivate)
        // Final private
        XCTAssertFalse(instanceUnderTest.actors[5].isInternal)
        XCTAssertFalse(instanceUnderTest.actors[5].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[5].isOpen)
        XCTAssertTrue(instanceUnderTest.actors[5].isFinal)
        XCTAssertTrue(instanceUnderTest.actors[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.actors[5].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.actors[6].isInternal)
        XCTAssertFalse(instanceUnderTest.actors[6].isPublic)
        XCTAssertFalse(instanceUnderTest.actors[6].isOpen)
        XCTAssertFalse(instanceUnderTest.actors[6].isFinal)
        XCTAssertFalse(instanceUnderTest.actors[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.actors[6].isFilePrivate)
    }

    func test_modifierAssessing_protocols_willResolveExpectedValues() {
        let source = #"""
        protocol Example {}
        public protocol Example {}
        private protocol Example {}
        fileprivate protocol Example {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.protocols.count, 4)
        // Internal
        XCTAssertTrue(instanceUnderTest.protocols[0].isInternal)
        XCTAssertFalse(instanceUnderTest.protocols[0].isPublic)
        XCTAssertFalse(instanceUnderTest.protocols[0].isOpen)
        XCTAssertFalse(instanceUnderTest.protocols[0].isFinal)
        XCTAssertFalse(instanceUnderTest.protocols[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.protocols[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.protocols[1].isInternal)
        XCTAssertTrue(instanceUnderTest.protocols[1].isPublic)
        XCTAssertFalse(instanceUnderTest.protocols[1].isOpen)
        XCTAssertFalse(instanceUnderTest.protocols[1].isFinal)
        XCTAssertFalse(instanceUnderTest.protocols[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.protocols[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.protocols[2].isInternal)
        XCTAssertFalse(instanceUnderTest.protocols[2].isPublic)
        XCTAssertFalse(instanceUnderTest.protocols[2].isOpen)
        XCTAssertFalse(instanceUnderTest.protocols[2].isFinal)
        XCTAssertTrue(instanceUnderTest.protocols[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.protocols[2].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.protocols[3].isInternal)
        XCTAssertFalse(instanceUnderTest.protocols[3].isPublic)
        XCTAssertFalse(instanceUnderTest.protocols[3].isOpen)
        XCTAssertFalse(instanceUnderTest.protocols[3].isFinal)
        XCTAssertFalse(instanceUnderTest.protocols[3].isPrivate)
        XCTAssertTrue(instanceUnderTest.protocols[3].isFilePrivate)
    }

    func test_modifierAssessing_subscripts_willResolveExpectedValues() {
        let source = #"""
        subscript(key: Int) -> Int {}
        public subscript(key: Int) -> Int {}
        private subscript(key: Int) -> Int {}
        open subscript(key: Int) -> Int {}
        final subscript(key: Int) -> Int {}
        public final subscript(key: Int) -> Int {}
        fileprivate subscript(key: Int) -> Int {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.subscripts.count, 7)
        // Internal
        XCTAssertTrue(instanceUnderTest.subscripts[0].isInternal)
        XCTAssertFalse(instanceUnderTest.subscripts[0].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[0].isOpen)
        XCTAssertFalse(instanceUnderTest.subscripts[0].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[0].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.subscripts[1].isInternal)
        XCTAssertTrue(instanceUnderTest.subscripts[1].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[1].isOpen)
        XCTAssertFalse(instanceUnderTest.subscripts[1].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[1].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.subscripts[2].isInternal)
        XCTAssertFalse(instanceUnderTest.subscripts[2].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[2].isOpen)
        XCTAssertFalse(instanceUnderTest.subscripts[2].isFinal)
        XCTAssertTrue(instanceUnderTest.subscripts[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[2].isFilePrivate)
        // Open
        XCTAssertFalse(instanceUnderTest.subscripts[3].isInternal)
        XCTAssertFalse(instanceUnderTest.subscripts[3].isPublic)
        XCTAssertTrue(instanceUnderTest.subscripts[3].isOpen)
        XCTAssertFalse(instanceUnderTest.subscripts[3].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[3].isFilePrivate)
        // Final
        XCTAssertTrue(instanceUnderTest.subscripts[4].isInternal)
        XCTAssertFalse(instanceUnderTest.subscripts[4].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[4].isOpen)
        XCTAssertTrue(instanceUnderTest.subscripts[4].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[4].isFilePrivate)
        // Public Final
        XCTAssertFalse(instanceUnderTest.subscripts[5].isInternal)
        XCTAssertTrue(instanceUnderTest.subscripts[5].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[5].isOpen)
        XCTAssertTrue(instanceUnderTest.subscripts[5].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.subscripts[5].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.subscripts[6].isInternal)
        XCTAssertFalse(instanceUnderTest.subscripts[6].isPublic)
        XCTAssertFalse(instanceUnderTest.subscripts[6].isOpen)
        XCTAssertFalse(instanceUnderTest.subscripts[6].isFinal)
        XCTAssertFalse(instanceUnderTest.subscripts[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.subscripts[6].isFilePrivate)
    }

    func test_modifierAssessing_initializer_willResolveExpectedValues() {
        let source = #"""
        init(key: Int) {}
        public init(key: Int) {}
        private init(key: Int) {}
        required init(key: Int) {}
        public required init(key: Int) {}
        private required init(key: Int) {}
        convenience init(key: Int) {}
        public convenience init(key: Int) {}
        private convenience init(key: Int) {}
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.initializers.count, 9)
        // Internal
        XCTAssertTrue(instanceUnderTest.initializers[0].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[0].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[0].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[0].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[0].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[0].isRequired)
        // Public
        XCTAssertFalse(instanceUnderTest.initializers[1].isInternal)
        XCTAssertTrue(instanceUnderTest.initializers[1].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[1].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[1].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[1].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[1].isRequired)
        // Private
        XCTAssertFalse(instanceUnderTest.initializers[2].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[2].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[2].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[2].isFinal)
        XCTAssertTrue(instanceUnderTest.initializers[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[2].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[2].isRequired)
        // Required internal
        XCTAssertTrue(instanceUnderTest.initializers[3].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[3].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[3].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[3].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[3].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[3].isConvenience)
        XCTAssertTrue(instanceUnderTest.initializers[3].isRequired)
        // Required public
        XCTAssertFalse(instanceUnderTest.initializers[4].isInternal)
        XCTAssertTrue(instanceUnderTest.initializers[4].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[4].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[4].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[4].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[4].isConvenience)
        XCTAssertTrue(instanceUnderTest.initializers[4].isRequired)
        // Required private
        XCTAssertFalse(instanceUnderTest.initializers[5].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[5].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[5].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[5].isFinal)
        XCTAssertTrue(instanceUnderTest.initializers[5].isPrivate)
        XCTAssertFalse(instanceUnderTest.initializers[5].isConvenience)
        XCTAssertTrue(instanceUnderTest.initializers[5].isRequired)
        // Convenience
        XCTAssertTrue(instanceUnderTest.initializers[6].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[6].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[6].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[6].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[6].isPrivate)
        XCTAssertTrue(instanceUnderTest.initializers[6].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[6].isRequired)
        // Convenience public
        XCTAssertFalse(instanceUnderTest.initializers[7].isInternal)
        XCTAssertTrue(instanceUnderTest.initializers[7].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[7].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[7].isFinal)
        XCTAssertFalse(instanceUnderTest.initializers[7].isPrivate)
        XCTAssertTrue(instanceUnderTest.initializers[7].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[7].isRequired)
        // Convenience private
        XCTAssertFalse(instanceUnderTest.initializers[8].isInternal)
        XCTAssertFalse(instanceUnderTest.initializers[8].isPublic)
        XCTAssertFalse(instanceUnderTest.initializers[8].isOpen)
        XCTAssertFalse(instanceUnderTest.initializers[8].isFinal)
        XCTAssertTrue(instanceUnderTest.initializers[8].isPrivate)
        XCTAssertTrue(instanceUnderTest.initializers[8].isConvenience)
        XCTAssertFalse(instanceUnderTest.initializers[8].isRequired)
    }

    func test_modifierAssessing_typealias_willResolveExpectedValues() {
        let source = #"""
        typealias Example = String
        public typealias Example = String
        private typealias Example = String
        fileprivate typealias Example = String
        """#
        instanceUnderTest.updateToSource(source)
        XCTAssertTrue(instanceUnderTest.isStale)
        instanceUnderTest.collectChildren()
        XCTAssertFalse(instanceUnderTest.isStale)
        XCTAssertEqual(instanceUnderTest.typealiases.count, 4)
        // Internal
        XCTAssertTrue(instanceUnderTest.typealiases[0].isInternal)
        XCTAssertFalse(instanceUnderTest.typealiases[0].isPublic)
        XCTAssertFalse(instanceUnderTest.typealiases[0].isOpen)
        XCTAssertFalse(instanceUnderTest.typealiases[0].isFinal)
        XCTAssertFalse(instanceUnderTest.typealiases[0].isPrivate)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isFilePrivate)
        // Public
        XCTAssertFalse(instanceUnderTest.typealiases[1].isInternal)
        XCTAssertTrue(instanceUnderTest.typealiases[1].isPublic)
        XCTAssertFalse(instanceUnderTest.typealiases[1].isOpen)
        XCTAssertFalse(instanceUnderTest.typealiases[1].isFinal)
        XCTAssertFalse(instanceUnderTest.typealiases[1].isPrivate)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isFilePrivate)
        // Private
        XCTAssertFalse(instanceUnderTest.typealiases[2].isInternal)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isPublic)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isOpen)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isFinal)
        XCTAssertTrue(instanceUnderTest.typealiases[2].isPrivate)
        XCTAssertFalse(instanceUnderTest.typealiases[2].isFilePrivate)
        // fileprivate
        XCTAssertFalse(instanceUnderTest.typealiases[3].isInternal)
        XCTAssertFalse(instanceUnderTest.typealiases[3].isPublic)
        XCTAssertFalse(instanceUnderTest.typealiases[3].isOpen)
        XCTAssertFalse(instanceUnderTest.typealiases[3].isFinal)
        XCTAssertFalse(instanceUnderTest.typealiases[3].isPrivate)
        XCTAssertTrue(instanceUnderTest.typealiases[3].isFilePrivate)
    }
}
