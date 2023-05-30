//
//  SyntaxTree.swift
//  
//
//  Copyright (c) CheekyGhost Labs 2023. All Rights Reserved.
//

import Foundation
import SwiftSyntax

/// Represents a syntax tree in Swift.
///
/// `SyntaxTree` provides a mechanism to analyze and interact with Swift source code as a syntax tree. It collects semantic structures from the
/// source code and allows you to access them conveniently.
///
/// `SyntaxTree` can be initialized with a file path or directly with a source code string, both of which are represented as syntax trees. Once initialized,
/// you can use various properties to access the collected semantic structures, such as classes, deinitializers, enumerations, extensions, functions, imports,
/// initializers, operators, precedenceGroups, protocols, structures, subscripts, typealiases, variables, and conditionalCompilationBlocks.
///
/// `SyntaxTree` also allows updating the source code, triggering a re-analysis of the syntax tree and updating the collected semantic structures accordingly.
///
/// Note that `SyntaxTree` uses a `SyntaxExplorerContext` to store information about the syntax tree, and it shares this context with any child elements
/// that require lazy evaluation or collection as needed.
public class SyntaxTree: SyntaxChildCollecting, SyntaxExplorerContextProviding {

    // MARK: - Properties: SyntaxExplorerContextProviding

    /// `SyntaxExplorerContext` instance holding root collection details and instances. This context will be shared with any child elements
    /// that require lazy evaluation or collection as needed.
    private(set) public var context: SyntaxExplorerContext

    // MARK: - Properties: DeclarationCollecting

    /// `RootDeclarationCollector` instance for collecting immediate child declarations.
    private(set) lazy var declarationCollector: RootDeclarationCollector = context.createRootDeclarationCollector()

    // MARK: - Lifecycle

    /// Convenience for initializing with the contents of a given source file.
    ///
    /// - Parameters:
    ///   - viewMode: The parsing and traversal strategy to apply when procssing source code.
    ///   - path: The file path to the source to load.
    public convenience init(viewMode: SyntaxTreeViewMode, sourceAtPath path: String) throws {
        do {
            let fileUrl = URL(filePath: path)
            let contents = try String(contentsOf: fileUrl)
            self.init(viewMode: viewMode, sourceBuffer: contents)
        } catch {
            throw error
        }
    }

    /// Initializes a new instance for analyzing the provided source code.
    ///
    /// - Parameters:
    ///   - viewMode: The parsing and traversal strategy to apply when procssing source code.
    ///   - sourceBuffer: The raw source being assessed.
    public required init(viewMode: SyntaxTreeViewMode, sourceBuffer: String) {
        self.context = SyntaxExplorerContext(viewMode: viewMode, sourceBuffer: sourceBuffer)
    }

    // MARK: - Conformance: SyntaxExploring

    /// Updates the source code being analyzed and refreshes the collected instances accordingly.
    ///
    /// This method replaces the current source code with the new source code provided, and
    /// re-analyzes it to update the collected semantic structures. The primary intent of this
    /// method is to adjust for changes in the source code, such as modifications, additions,
    /// or deletions. However, it can also be used to switch to a completely different source code,
    /// if necessary.
    ///
    /// This method performs a full re-analysis of the source code, which might be
    /// computationally expensive for large code bases. A future enhancement could involve
    /// diffing the old and new source code to only update the parts of the analysis that have
    /// changed, improving performance for incremental changes.
    ///
    /// It's important to note that, after calling this method, previously retrieved instances
    /// might no longer be accurate or relevant. Therefore, it is recommended to re-fetch any
    /// instances from the explorer after calling this method.
    ///
    /// - Parameter source: The new source code to analyze.
    public func updateToSource(_ source: String) {
        context.updateSourceBuffer(to: source)
    }

    /// This method walks through the syntax tree and collects root-level semantic declarations into their respective arrays.
    /// The exploration will stop at the respective source level for each semantic structure, as some declarations also support further exploration.
    /// Consider the following example:
    /// ```swift
    /// struct MyStruct {
    ///   struct NestedStruct { ... }
    ///   enum NestedEnum { ... }
    /// }
    /// enum MyEnum {
    ///   case example
    ///   static func performOperation() { ... }
    /// }
    /// ```
    /// After invoking `walk`, the results will be:
    /// - `structures` will contain: `[MyStruct]`
    /// - `enumerations` will contain: `[MyEnum]`
    /// Furthermore, `MyStruct` and `MyEnum` will provide access to their child semantics.
    /// - `MyStruct.structures` will contain: `[NestedStruct]`
    /// - `MyStruct.enumerations` will contain: `[NestedEnum]`
    /// - `MyEnum.functions` will contain: `[performOperation]`
    ///
    /// Thus, `walk` facilitates a hierarchical exploration of the syntax tree.
    public func collectChildren() throws {
        do {
            try declarationCollector.collect(fromSource: context.sourceBuffer)
            context.resetIsStale()
        } catch {
            // log error
            print(error)
        }
    }

    // MARK: - Conformance: SyntaxChildCollecting

    public var classes: [Class] { declarationCollector.collection.classes }
    public var deinitializers: [Deinitializer] { declarationCollector.collection.deinitializers }
    public var enumerations: [Enumeration] { declarationCollector.collection.enumerations }
    public var extensions: [Extension] { declarationCollector.collection.extensions }
    public var functions: [Function] { declarationCollector.collection.functions }
    public var imports: [Import] { declarationCollector.collection.imports }
    public var initializers: [Initializer] { declarationCollector.collection.initializers }
    public var operators: [Operator] { declarationCollector.collection.operators }
    public var precedenceGroups: [PrecedenceGroup] { declarationCollector.collection.precedenceGroups }
    public var protocols: [`Protocol`] { declarationCollector.collection.protocols }
    public var structures: [Structure] { declarationCollector.collection.structures }
    public var subscripts: [Subscript] { declarationCollector.collection.subscripts }
    public var typealiases: [Typealias] { declarationCollector.collection.typealiases }
    public var variables: [Variable] { declarationCollector.collection.variables }
    public var conditionalCompilationBlocks: [ConditionalCompilationBlock] {
        declarationCollector.collection.conditionalCompilationBlocks
    }

    // MARK: - Conformance: SyntaxExplorerContextProviding

    public var sourceBuffer: String { context.sourceBuffer }

    public var viewMode: SyntaxTreeViewMode { context.viewMode }

    public var sourceLocationConverter: SparrowSourceLocationConverter { context.sourceLocationConverter }

    public var isStale: Bool { context.isStale }
}
