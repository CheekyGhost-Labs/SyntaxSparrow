# SyntaxSparrow


# SyntaxSparrow

SyntaxSparrow is a Swift library designed to facilitate the analysis and interaction with Swift source code. It leverages SwiftSyntax to parse Swift code and produce a syntax tree which collects and traverses constituent declaration types for Swift code.

## Features

- **Swift Code Analysis**: Parse Swift code and create a syntax tree for in-depth analysis.
- **Semantic Extraction**: Extracts various semantic structures like classes, functions, enumerations, structures, protocols, etc. from the syntax tree.
- **Source Code Updates**: Ability to update the source code on a tree instance, allowing subsequent collections as code changes.
- **Different View Modes**: Control the parsing and traversal strategy when processing the source code.
- **Lazy Evaluation**: Shared context with child elements for lazy evaluation or collection as needed.
- **Heirachy Based**: Semantic types support child declarations (where relevant) to allow for a more heirachy-based traversal.

## Usage

Initialize `SyntaxTree` with the path of a Swift source file or directly with a Swift source code string. Then, use the various properties of `SyntaxTree` to access the collected semantic structures. 

```swift
let syntaxTree = try SyntaxTree(viewMode: .fixedUp, sourceAtPath: "/path/to/your/swift/file")
syntaxTree.collectChildren()
```

Or you can initialize it directly with a source code string:

```swift
let sourceCode = """
struct MyStruct {

    enum MyEnum {    
        case sample
        case otherSample
    }
    
    let myProperty: String
}
"""
let syntaxTree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: sourceCode)
syntaxTree.collectChildren()
```

### Using Constituent Declarations:

After initialization and collection, you can access the collected semantic structures:

```swift
syntaxTree.structures[0] // MyStruct
syntaxTree.structures[0].enumerations[0] // MyEnum
syntaxTree.structures[0].enumerations[0].cases // [sample, otherSample]
syntaxTree.structures[0].variables[0] // myProperty
```

If you want to update the source code and refresh the semantic structures:

```swift
syntaxTree.updateToSource(newSourceCode)
syntaxTree.collectChildren()
```

## Installation

Currently, SyntaxSparrow supports Swift Package Manager (SPM).

To add SyntaxSparrow to your project, add the following line to your dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/CheekyGhost-Labs/SyntaxSparrow", from: "1.0.0")
```

Then, add SyntaxSparrow as a dependency for your target:

```swift
.target(name: "YourTarget", dependencies: ["SyntaxSparrow"]),
```

## Requirements

- Swift 5.3+
- macOS 10.15+

## License

SyntaxSparrow is released under the MIT License. See the LICENSE file for more information.

## Contributing

Contributions to SyntaxSparrow are welcomed! If you have a bug to report, feel free to help out by opening a new issue or submitting a pull request