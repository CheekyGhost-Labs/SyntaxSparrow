# SyntaxSparrow

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCheekyGhost-Labs%2FSyntaxSparrow%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/CheekyGhost-Labs/SyntaxSparrow)

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FCheekyGhost-Labs%2FSyntaxSparrow%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/CheekyGhost-Labs/SyntaxSparrow)

SyntaxSparrow is a Swift library designed to facilitate the analysis and interaction with Swift source code. It leverages SwiftSyntax to parse Swift code and produce a syntax tree which collects and traverses constituent declaration types for Swift code.

## Workflows:

|  Branch  | Latest Swift/Xcode |
|:---------|:------------------:|
| main | [![Swift Unit Tests](https://github.com/CheekyGhost-Labs/SyntaxSparrow/actions/workflows/unit-tests.yml/badge.svg)](https://github.com/CheekyGhost-Labs/SyntaxSparrow/actions/workflows/unit-tests.yml) |
| develop | [![Swift Unit Tests](https://github.com/CheekyGhost-Labs/SyntaxSparrow/actions/workflows/unit-tests.yml/badge.svg?branch=develop)](https://github.com/CheekyGhost-Labs/SyntaxSparrow/actions/workflows/unit-tests.yml) |

- [About the Project](#about-the-project)
- [Features](#features)
- [Usage](#usage)
  - [General](#general)
  - [Updating To a New Source](#updating-to-a-new-source)
  - [Using Constituent Declarations](#using-constituent-declarations)
  - [Source Locations/Bounds](#source-locations-and-bounds)
  - [Entity Types](#entity-types)
- [Installation](#installation)
- [Requirements](#requirements)
- [License](#license)
- [Contributing](#contributing)

## About the Project
SyntaxSparrow was built on heavy inspiration from the now archived [SwiftSemantics](https://github.com/SwiftDocOrg/SwiftSemantics) project. `SwiftSemantics` was awesome, but being archived the only option is to fork and add features yourself, or hope someone has added your feature to their fork. `SyntaxSparrow` aims to pick up where this left off and add more support for conveniences, features, and harden parsing where needed.

The primary goal of producing semantic types to abstract the underlying `Syntax` expressions produced by `SwiftSyntax` remains the same, however there are a few other goals that `SyntaxSparrow` tries to achieve:

- **On-request evaluation**: As some source can be quite verbose and complex, SyntaxSparrow aims to only process and iterate through nodes as you request them. The goal being to improve performance and lets the collectors focus on high-level traversal. Whether this is worth the internal trade off from a code complexity perspective will be reviewed over updates. The publicly visible semantic types are not effected by any internal updates fortunately.

- **Source Locations**: `SyntaxSparrow` enables asking for where a declaration is within the provided source.

- **Heirachy Based**: Rather than flatten nested declarations into a single array, Declarations in `SyntaxSparrow` are able to collect child declarations as they are supported in swift. For example, nesting structs within an enum or extensions etc

- **Performance**: In the future, we aim to improve performance through more efficient parsing algorithms and data structures. This will be coupled with an expanded test suite, to ensure accuracy across a wider range of Swift code patterns and idioms. We're also looking at ways to allow users to tailor the library's behavior to their specific needs, such as customizable traversal strategies and fine-grained control over the amount of information collected.

## Features

- **Swift Macro Development**: Parse the raw SwiftSyntax declarations a macro provides into their semantic code to focus on your generated code.

- **Swift Code Analysis**: Parse Swift code and create a syntax tree for in-depth analysis.

- **Swift Code Generation**: Use parsed semantic types to generate code in a far more readable manner.

- **Semantic Extraction**: Extracts various semantic structures like classes, functions, enumerations, structures, protocols, etc. from the syntax tree into constituent types.

- **Source Code Updates**: Ability to update the source code on a tree instance, allowing subsequent collections as code changes.

- **Different View Modes**: Control the parsing and traversal strategy when processing the source code.

- **On-demand Evaluation**: The details of a semantic type are only loaded on request.

- **Heirachy Based**: Semantic types support child declarations (where relevant) to allow for a more heirachy-based traversal.

## Use Cases:

`SyntaxSparrow` is designed to enable source exploration, and to compliment tooling to achieve some common tasks. For example:

- **Code Generation**: Iterate through a readable semantic type to generate code to add to source via an IDE plugin, CLI, Swift Package Plugin etc

- **Static Code Analysis**: Explore parsed source code with more accuracy to compliment code analysis tasks. i.e Resolving function names to look up index symbols and check if they are tested or unused.

## Usage

### General

Initialize `SyntaxTree` with the path of a Swift source file, directly with a Swift source code string, or by asking to parse a `SwiftSyntax.DeclSyntaxProtocol` conforming type. Then, use the various properties of `SyntaxTree` to access the collected semantic structures. 

##### From Source File

```swift
let syntaxTree = try SyntaxTree(viewMode: .fixedUp, sourceAtPath: "/path/to/your/swift/file")
syntaxTree.collectChildren()
```

##### From Source

```swift
let syntaxTree = try SyntaxTree(viewMode: .fixedUp, sourceBuffer: "source code")
syntaxTree.collectChildren()
```

##### From SwiftSyntax.DeclSyntaxProtocol

```swift
let syntaxTree = try SyntaxTree(viewMode: .fixedUp, declarationSyntax: declaration)
syntaxTree.collectChildren()
```

### Updating To a New Source:

If you want to update the source code and refresh the semantic structures:

```swift
syntaxTree.updateToSource(newSourceCode)
syntaxTree.collectChildren()
```

### Using Constituent Declarations:

After initialization and collection, you can access the collected semantic structures and their properties, such as attributes, modifiers, name, etc:

```swift
let sourceCode = """
class MyViewController: UIViewController, UICollectionViewDelegate, ListItemDisplaying {
    
    @available(*, unavailable, message: "my message")
    enum Section {
        case summary, people
    }

    var people: [People], places: [Place]
    
    var person: (name: String, age: Int)?
    
    weak var delegate: MyDelegate?

    @IBOutlet private(set) var tableView: UITableView!
    
    struct MyStruct {

        enum MyEnum {    
            case sample(title: String)
            case otherSample
        }
    }
    
    func performOperation<T: Any>(input: T, _ completion: (Int) -> String) where T: NSFetchResult {
        typealias SampleAlias = String
    }
}
"""
let syntaxTree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: sourceCode)
syntaxTree.collectChildren()
//
syntaxTree.protocols[0].name // "ListItemDisplaying"
syntaxTree.protocols[0].functions[0].identifier // setListItems
syntaxTree.protocols[0].functions[0].signature.input[0].secondName // items
syntaxTree.protocols[0].functions[0].signature.input[0].isLabelOmitted // true
syntaxTree.protocols[0].functions[0].signature.input[0].type // .simple("[ListItem]")

syntaxTree.classes[0].name // MyViewController
syntaxTree.classes[0].inheritance // [UIViewController, UICollectionViewDelegate, ListItemDisplaying]
syntaxTree.classes[0].enumerations[0].name // Section
syntaxTree.classes[0].enumerations[0].cases.map(\.name) // [summary, people]
syntaxTree.classes[0].enumerations[0].attributes[0].name // available
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[0].name // nil
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[0].value // *
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[1].name // nil
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[1].value // unavailable
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[2].name // "message"
syntaxTree.classes[0].enumerations[0].attributes[0].arguments[2].value // "my message"

syntaxTree.classes[0].variables[0].name // people
syntaxTree.classes[0].variables[0].type // .simple("[People]")
syntaxTree.classes[0].variables[1].name // places
syntaxTree.classes[0].variables[1].type // .simple("[Place]")
syntaxTree.classes[0].variables[2].name // person
syntaxTree.classes[0].variables[2].type // .tuple(Tuple)
syntaxTree.classes[0].variables[2].isOptional // true

switch syntaxTree.classes[0].variables[1].type {
case .tuple(let tuple):
    tuple.elements.map(\.name) // [name, age]
    tuple.isOptional // true
}

syntaxTree.classes[0].variables[3].type // .simple("MyDelegate")
syntaxTree.classes[0].variables[3].isOptional // true
syntaxTree.classes[0].variables[3].modifiers.map(\.name) // [weak]

syntaxTree.structures[0].name // MyStruct
syntaxTree.structures[0].enumerations[0] // MyEnum
syntaxTree.structures[0].enumerations[0].cases[0].associatedValues.map(\.name) // [title]

syntaxTree.functions[0].identifier // performOperation
syntaxTree.functions[0].genericParameters.map(\.name) // [T]
syntaxTree.functions[0].genericParameters.map(\.type) // [Any]
syntaxTree.functions[0].genericRequirements.map(\.name) // [T]
syntaxTree.functions[0].genericRequirements[0].leftTypeIdentifier // T
syntaxTree.functions[0].genericRequirements[0].rightTypeIdentifier // NSFetchResult
syntaxTree.functions[0].genericRequirements[0].relation // .sameType
syntaxTree.functions[0].typealiases[0].name // SampleAlias
syntaxTree.functions[0].typealiases[0].initializedType.type // .simple("String")
```

### Source Locations and Bounds:
`Declaration` types can can also be sent to the `SyntaxTree` to extract source location and content:

```swift
let sourceCode = """
    enum Section {
        case summary
        case people
    }
    
    @available(*, unavailable, message: "my message")
    struct MyStruct {
        var name: String = "name"
    }
"""
let syntaxTree = SyntaxTree(viewMode: .fixedUp, sourceBuffer: sourceCode)
syntaxTree.collectChildren()
let sourceDetails = try syntaxTree.extractSource(forDeclaration: structure)

sourceDetails.location.start.line // 5
sourceDetails.location.start.column // 4
sourceDetails.location.end.line // 8
sourceDetails.location.end.line // 4
sourceDetails.source // "@available(*, unavailable, message: \"my message\")\nstruct MyStruct {\n    var name: String = \"name\"\n}"

// The `SyntaxSourceDetails` struct also has some conveniences for calculating ranges
sourceDetails.substringRange(in: source) // Range<String.Index>
sourceDetails.stringRange(in: source) // NSRange(location: 51, length: 99)
```

### Entity Types:
`EntityType` is a vital part of SyntaxSparrow. It represents the type of an entity within a Swift source code. These entities can include parameters, variables, function return types, etc.

It provides a structured representation for type information extracted from the Swift code. EntityType has a comprehensive support for many Swift types, handling simple, optional, tuple, function, and result types.

The various EntityType options include:

- simple: Represents a simple type like `Int`, `String`, `Bool`, or any other user-defined types.
- tuple: Represents tuple types, such as `(Int, String)`
- closure: Represents function or closure types, like `(Int, String) -> Bool`
- Array: Represents a swift array via shorthand `[Type]` or keyword `Array<Type>` 
- Set: Represents a swift set via keyword `Set<Type>` 
- Dictionary: Represents a swift dictionary via shorthand `[Type: Type]` or keyword `Dictionary<Type, Type>` 
- result: Represents Swift's Result type, capturing the Success and Failure types.
- void: Represents a void block type. i.e `Void` or `()`
- empty: Used to capture partial declarations where a type is not defined yet. i.e `var myName: `

EntityType provides an easily accessible way to extract type-related information from your Swift source code.

For Example,

```swift
let function = syntaxTree.functions.first
let returnType = function?.returnType  // This is an EntityType
```

You can then inspect the returnType to determine its specifics

```swift
switch returnType {
case .simple(let typeName):
    print("Simple type: \(typeName)")
case .tuple(let tuple):
    tuple.isOptional // true/false
    tuple.elements // Array of `Parameter` types
case .array(let array):
    array.isOptional // true/false
    array.elementType // Entity Type
    array.declType // .squareBrackets/.generic
case .set(let set):
    set.isOptional // true/false
    set.elementType // Entity Type
case .dictionary(let dict):
    dict.isOptional // true/false
    dict.keyType // Entity Type
    dict.valueType // Entity Type
    dict.declType // .squareBrackets/.generics
case .closure(let closure):
    closure.input // Entity Type
    closure.output // Entity Type
    closure.isEscaping // true/false
    closure.isAutoEscaping // true/false
    closure.isOptional // true/false
    closure.isVoidInput // true/false
    closure.isVoidOutput // true/false
    // see `Closure`
case .result(let result):
    print(result.successType) // EntityType
    print(result.failureType) // EntityType
    // see `Tuple`
case .void(let rawType: let isOptional):
   print(rawType) // "Void" or "()?" etc
case .empty:
   print("undefined or partial")
}

```

## Installation

Currently, SyntaxSparrow supports Swift Package Manager (SPM).

To add SyntaxSparrow to your project, add the following line to your dependencies in your Package.swift file:

```swift
.package(url: "https://github.com/CheekyGhost-Labs/SyntaxSparrow", from: "3.0.0")
```

Then, add SyntaxSparrow as a dependency for your target:

```swift
.target(name: "YourTarget", dependencies: ["SyntaxSparrow"]),
```

## Requirements

- Swift 5.7+
- macOS 10.15+

## License

SyntaxSparrow is released under the MIT License. See the LICENSE file for more information.

## Contributing

Contributions to SyntaxSparrow are welcomed! If you have a bug to report, feel free to help out by opening a new issue or submitting a pull request.

SyntaxSparrow follows pretty closely to a standard git flow process. For the most part, pull requests should be made against the `develop` branch to coordinate any releases. This also provides a means to test from the `develop` branch in the wild to further test pending releases. Once a release is ready it will be merged into `main`, tagged, and have a release branch cut.

#### To get started:

1. **Fork the repository**: Start by creating a fork of the project to your own GitHub account.

2. **Clone the forked repository**: After forking, clone your forked repository to your local machine so you can make changes.

```shell
git clone https://github.com/CheekyGhost-Labs/SyntaxSparrow.git
```

3. **Create a new branch**: Before making changes, create a new branch for your feature or bug fix. Use a descriptive name that reflects the purpose of your changes.

```shell
git checkout -b your-feature-branch
```

4. **Follow the Swift Language Guide**: Ensure that your code adheres to the [Swift Language Guide](https://swift.org/documentation/api-design-guidelines/) for styling and syntax conventions.

5. **Make your changes**: Implement your feature or bug fix, following the project's code style and best practices. Don't forget to add tests and update documentation as needed.

6. **Commit your changes**: Commit your changes with a descriptive and concise commit message. Use the imperative mood, and explain what your commit does, rather than what you did.

```shell

# Feature
git commit -m "Feature: Adding convenience method for resolving awesomeness"


# Bug
git commit -m "Bug: Fixing issue where awesome query was not including awesome"
```

7. **Pull the latest changes from the upstream**: Before submitting your changes, make sure to pull the latest changes from the upstream repository and merge them into your branch. This helps to avoid any potential merge conflicts.

```shell
git pull origin develop
```

8. **Push your changes**: Push your changes to your forked repository on GitHub.

```shell
git push origin your-feature-branch
```

9. **Submit a pull request**: Finally, create a pull request from your forked repository to the original repository, targeting the `develop` branch. Fill in the pull request template with the necessary details, and wait for the project maintainers to review your contribution.

### Unit Testing

Please ensure you add unit tests for any changes. The aim is not `100%` coverage, but rather meaningful test coverage that ensures your changes are behaving as expected without negatively effecting existing behavior.

Please note that the project maintainers may ask you to make changes to your contribution or provide additional information. Be open to feedback and willing to make adjustments as needed. Once your pull request is approved and merged, your changes will become part of the project!