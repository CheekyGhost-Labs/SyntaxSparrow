//
//  SyntaxSparrowTests.swift
//
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

@testable import SyntaxSparrow
import XCTest

private extension DeclarationCollection {
    var allDeclarations: [any Declaration] {
        var results: [any Declaration] = []
        results.append(contentsOf: classes)
        results.append(contentsOf: conditionalCompilationBlocks)
        results.append(contentsOf: deinitializers)
        results.append(contentsOf: enumerations)
        results.append(contentsOf: extensions)
        results.append(contentsOf: functions)
        results.append(contentsOf: imports)
        results.append(contentsOf: initializers)
        results.append(contentsOf: operators)
        results.append(contentsOf: precedenceGroups)
        results.append(contentsOf: protocols)
        results.append(contentsOf: structures)
        results.append(contentsOf: subscripts)
        results.append(contentsOf: typealiases)
        results.append(contentsOf: variables)
        return results
    }
}

final class SyntaxSparrowTests: XCTestCase {

    // MARK: - Properties
    let source = #"""
    #if DEBUG
    typealias StringAlias = String
    struct DebugStruct { }
    class DebugClass { }
    enum DebugEnum { case debug }
    func debugFunction() { }
    var debugVariable: Int = 0
    protocol DebugProtocol { }
    subscript(_ idx: Int) -> Int { return idx }
    init() { }
    deinit { print("Debug deinit") }
    infix operator +-: DebugOperator
    extension String {}
    #else
    typealias IntAlias = Int
    struct ReleaseStruct { }
    class ReleaseClass { }
    enum ReleaseEnum { case release }
    func releaseFunction() { }
    var releaseVariable: Int = 0
    protocol ReleaseProtocol { }
    subscript(_ idx: Int) -> Int { return idx }
    init() { }
    deinit { print("Release deinit") }
    infix operator --: ReleaseOperator
    extension Int {}
    #endif
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
        var person: (name: String, age: Int?) = ("name", 20)
        var person: (name: String, age: Int?)? = ("name", 20)

        class NestedClass {
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
            public enum MyEnum: String {
                case one
                case two

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
        }
        func noParameters() throws {}
        func labelOmitted(_ name: String) {}
        func singleName(name: String) {}
        func singleNameOptional(name: String?) {}
        func twoNames(withName name: String) {}
        func optionalSimple(_ name: String?) {}
        func variadic(names: String...) {}
        func variadicOptional(_ names: String?...) {}
        func multipleParameters(name: String, age: Int?) {}
        func throwing(name: String, age: Int?) throws {}
        func tuple(person: (name: String, age: Int?)?) {}
        func closure(_ handler: @escaping (Int) -> Void) {}
        func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
        func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
        func result(processResult: Result<String, Error>) {}
        func resultOptional(processResult: Result<String, Error>?) {}
        func defaultValue(name: String = "name") {}
        func inoutValue(names: inout [String]) {}
    }
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
        var person: (name: String, age: Int?) = ("name", 20)
        var person: (name: String, age: Int?)? = ("name", 20)

        struct NestedStructTwo {
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
            public enum MyEnum: String {
                case one
                case two

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
        }
        func noParameters() throws {}
        func labelOmitted(_ name: String) {}
        func singleName(name: String) {}
        func singleNameOptional(name: String?) {}
        func twoNames(withName name: String) {}
        func optionalSimple(_ name: String?) {}
        func variadic(names: String...) {}
        func variadicOptional(_ names: String?...) {}
        func multipleParameters(name: String, age: Int?) {}
        func throwing(name: String, age: Int?) throws {}
        func tuple(person: (name: String, age: Int?)?) {}
        func closure(_ handler: @escaping (Int) -> Void) {}
        func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
        func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
        func result(processResult: Result<String, Error>) {}
        func resultOptional(processResult: Result<String, Error>?) {}
        func defaultValue(name: String = "name") {}
        func inoutValue(names: inout [String]) {}
    }
    func noParameters() throws {}
    func labelOmitted(_ name: String) {}
    func singleName(name: String) {}
    func singleNameOptional(name: String?) {}
    func twoNames(withName name: String) {}
    func optionalSimple(_ name: String?) {}
    func variadic(names: String...) {}
    func variadicOptional(_ names: String?...) {}
    func multipleParameters(name: String, age: Int?) {}
    func throwing(name: String, age: Int?) throws {}
    func tuple(person: (name: String, age: Int?)?) {}
    func closure(_ handler: @escaping (Int) -> Void) {}
    func autoEscapingClosure(_ handler: ((Int) -> Void)?) {}
    func complexClosure(_ handler: ((name: String, age: Int) -> String?)?) {}
    func result(processResult: Result<String, Error>) {}
    func resultOptional(processResult: Result<String, Error>?) {}
    func defaultValue(name: String = "name") {}
    func inoutValue(names: inout [String]) {}
    var person: (name: String, age: Int?) = ("name", 20)
    var person: (name: String, age: Int?)? = ("name", 20)
    protocol GenericRequirementProtocol<T> where T: Hashable {}
    protocol PrimaryAssociatedTypeProtocol<T, U> {}
    protocol A {}
    protocol B {}
    protocol InheritanceProtocol: A, B {}
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
        public enum MyEnum: String {
            case one
            case two

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
    }
    public enum MyEnum: String {
        case one
        case two

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

    // MARK: - Helpers

    func performTraversedSourceLocationCheck(on collection: DeclarationCollection, tree: SyntaxTree) {
        collection.allDeclarations.forEach {
            _ = try? tree.extractSource(forDeclaration: $0)
            if let collecting = $0 as? SyntaxChildCollecting {
                performTraversedSourceLocationCheck(on: collecting.childCollection, tree: tree)
            }
        }
    }

    // MARK: - Performance

    // These are for testing performance on refactors and as a base point for future changes. They are disabled by way of a `x_` prefix.

    func x_test_initialCollectionPerformance() throws {
        self.measure {
            let tree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: source)
            tree.collectChildren()
        }
    }

    func x_test_sourceResolving_topLevelOnly_Performance() throws {
        self.measure {
            let tree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: source)
            tree.collectChildren()
            tree.childCollection.allDeclarations.forEach {
                _ = try? tree.extractSource(forDeclaration: $0)
            }
        }
    }

    func x_test_sourceResolving_traversed_Performance() throws {
        self.measure {
            let tree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: source)
            tree.collectChildren()
            performTraversedSourceLocationCheck(on: tree.childCollection, tree: tree)
        }
    }
}
