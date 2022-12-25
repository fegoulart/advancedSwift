# 6 Enums

## Overview

Enums belong to a fundamentally different category. They are not record types like Structs and Classes.
Enums are tagged unions, or variant types.
Variants are commonplace in functional languages. 
Enums are one of Swift's best features.

An enum consists of zero or more cases, with each case having an optional tuple-style list of associated values.

We will use the term associated value when we talk about a single case's associated value(s). 
A case can have multiple associated values, but you can think of them as a single tuple.

enum TextAlignment {
    case left
    case center
    case right
} 

let alignment = TextAlignment.left
let download = Result<String, NetworkError> = .success("<p>Hello World!</p>")

### Enums are value types

Enums cannot have stored properties.
An enum's state is fully represented by its case plus the case's associated value.
Think of associated values as the stored properties for a particular case.

Enums are similiar to structs:

* Can have methods, computed properties and subscripts
* Methods can be declared mutating or not mutating
* We can write extensions for enums
* Enums can conform to protocols

Enums don't have stored properties and there's no way to mutate a case's associated value directly.
We mutate an enum assigning a new value directly to self. 

Enums don't require explicit initializers because the usual way to initialize an enum variable is to assign it a case.

However, it is possible to add convenience initializers in the type definition or in an extension.

Example of a convenience init:

extension TextAlignment {
    init(defaultFor locale: Locale) {
        guard let language = locale.languageCode else {
            // default for n/a language
            self = .left
            return
        }
        switch Locale.characterDirection(forLanguange: language) {
            case .rightToLeft:
                self = .right
            case .leftToRight, .topToBottom, .bottomToTop, .unknown:
                self = .left
            @unknown default:
                self = .left
        }
    }
}

let english = Locale(identifier: "en_AU")
TextAlignment(defaultFor: english) // left

## Sum Types and Product Types

An instance of record type contains values for all its fields.

An enum type value contains exactly one of its cases (plus associated value).

Before the public release of Swift, enum was called "oneof" and later "union".

Exemplo: Result<Success, Failure> tem só um valor: o do sucesso OU o da falha.
Portanto podemos pensar em um Enum como um "OU".

This ability to model "or" relationships is fairly unique and it's what makes enums so useful.
Fairly unique because protocols and subclassing can be used for it as well with very different tradeoffs and applications.

### Enum vs Protocols and Subclassing

A variable of a protocol can be one of any type that conforms to the protocol.
An object of type UIView can also refer to any one of UIView's direct or indirect subclasses. 
Downcast the instance to a concrete subtype in order to access data that's unique to that subtype is equivalent to switching over an enum.
Use the common base type interface  is equivalent to calling methods defined on an enum  

Different approaches: 

* Dynamic dispatch - used through the common interface for protocols and classes
* Switching - for enums

Particular capabilities and limitations:

* List of cases of an enum is fixed and can't be extended retroactively (but you can always conform one more type to a protocol or add another subclass. You need to declare a class open to allow subclassing across module boundaries)

### Plain old values

As value types, enums are generally more lightweight and better suited for modeling 'plain old values'.

### Correspondence between or and and types and mathematical concepts of addition and multiplication

What is a type ?
Many definitions:

One of them: Type is a set of all possible values, or inhabitants, its intances can assume.
Bool has 2 inhabitants: false and true
UInt8 has 2^8 = 256 inhabitants
Int64 has 2^64 inhabitants
String has infinitely many inhabitants
Tuple of 2 Booleans: 4 inhabitants

GENERALLY SPEAKING: THE NUMBER OF INHABITANTS OF A TUPLE (OR STRUCT OR CLASS) IS EQUAL TO THE PRODUCT OF THE INHABITANTS OF ITS MEMBERS
For this reason: structs, classes and tuples are PRODUCT TYPES

ENUMS ARE SUM TYPES: The number of inhabitants of an enum is equal to the sum of the inhabitants of its cases.
Adding one case to an enum only adds one additional inhabitant (or more dependending on associated value).

## Pattern matching

We commonly have to inspect the case and extract the associated value to do something useful with an enum.

Optionals for instance: we need to unwrap the associated value of the some case. Or abort if the inspected value is none case.

Most common way: switch statement.
Pattern matching isn't exclusive to switch statements but they are its most prominent use case.

Pattern matching let us decompose a data structure by its shape instead of just its contents.
The ability to combine pure matching with value binding makes it especially powerful.

underscore is the wildcard pattern

in addition to plain matching we can extract parts of a composite value and bind them to a variable.

let result: Result<(Int, String), Error> = ....

switch result {
    case .success(42, _): // UNDERSCORE IS WILDCARD
        print("Found the magic number")
    case .success(_):
        print("Found another number")
    case .failure(let error):
        print("Error: \(error)") // VALUE BINDING
}


### Pattern types

* Wildcard pattern: .success(42, _)
* Tuple pattern: (let x, 0, _)
* Enum case pattern: the only way to extract an enum's associated type value or match against a case while ignoring the associated value
* Value binding: binds part or all of a matched value to a new constant or variable. Syntax: let someIdentifier or var someIdentifier
* Optional patter: let value? is equivalent to .some(let value). nil match none case (overload of the ~= operator)
* Type casting pattern: let value as SomeType 
   ex: 
   let input: Any =
   switch input {
      case let integer as Int: 
} 
* Expression pattern: ~= for Equatable types forwards to == 
ex:

let randonNumber: Int8.random(in: .min...(.max))
switch randomNumber {
    case ..<0: 
    case 0:
    case 1...:
    default: fatalError("Can never happens")
}

### Value binding

let (x, y) and (let x, let y) are equivalent

(let x, y) binds a tuple first element to a new constant but compares the tuple's second element to the existing y variable

We can extend value-binding pattern with where case

.success(let httpStatus) where 200..<300 ˜= httpStatus
Importante: Where clause is evaluated after the value binding, so we can use the bound variables in the where clause


#### Multiple patterns in a single case

It is possible if all patterns use the same names and types in their value bindings.

Ex:

enum Shape {
    case line(from: Point, to: Point)
    case rectangle(origin: Point, width: Double, height: Double)
    case circle(center: Point, radius: Double)
}

switch shape {
    case .line(let origin, _),
    .rectangle(let origin, _, _),
    .circle(let origin, _):
        print("Origin point: ", origin)
}


### Overloading ~= operator

we can extend the pattern matching by overloading the ~= for our custom types
The function implementing ~= must have the following shape:

func ~=(pattern: ???, value: ???) -> Bool

We never found it necessary to extend pattern matching in this way

### Pattern matching in other contexts

pattern matching is not exclusive to enums nor is it exclusive to switch statements
ex: let x = 1 can be seen as a value-binding pattern on the left of the assignment operator

* Destructuring tuples in assignments: 
    let (word, pi) = ("Hello", 3.1415)
    for (key, value) in dictionary { ..... }
    
* Using wildcards to ignore values: for _ in 1...3
* Catching errors in a catch clause:
    do { ... } catch let error as NetworkError { }
* if case and guard case statements:  
    let color: ExtendedColor =
    if case .gray = color {
        print("Some shade of gray")
    }
    
    Here the assignment operator (=) is: perform a pattern match of the value on the right-hand with the pattern on the left-hand side
    
    if case .gray(let brightness) = color {
        print("Gray with brightness \(brightness)")
    }
* for case and while loops - similar to if case. 

## Designing with Enums

True sum types are a relatively uncommon feature among mainstream programming languages.

Six main points:

1. Switch exhaustively
2. Make illegal states impossible
3. Use enums for modeling state
4. Choosing between enums and structs
5. Parallels between enums and protocols
6. Use enums to model recursive data structures

### Switch exhaustively

A switch statement must be exhaustive

We recommend you avoid default cases in switch statements if at all possible

let shape: Shape = 

switch shape {
    case let .line(from, to) where from.y == to.y:
        print("...")
    case let .line(from, to) where from.x == to.x:
        print("...")
    case let .line(_, _):
        print("...")
    case .rectangle, .circle:
        print("rectangle or circle")
} 

### Make illegal states impossible

Compiler-driven development: seeing the compiler not as an enemy you have to fight, but as a tool that by using type information leads you almost magically to a correct solution.

USE TYPES TO MAKE ILLEGAL STATES UNREPRESENTABLE

Exemplo, trocar tupla pro Result (assim nunca chegarao dados para sucesso E erro)

### Use enums for modeling state

What is state ?

State is the contents of all variables at a given point in time, plus (implicitly) its current execution state (ex: which threads are running and which instructions they are executing).

State remembers things like what mode an application is in, what data is displaying, which user interaction it's currently processing etc

State space: set of states a system can be in.

### Try to make your program's state space as small as possible:

Enums model a finite number of states, they are ideal for modeling state and transition between states.
Because each state or enum case carries its own data it's easy to make illegal state combinations unrepresentable

example:

enum StateEnum {
    case loading
    case loaded([Message])
    case failed(Error) // we cannot transition to failed state without an Error
}

// Set initial state
var enumState = StateEnum.loading


enums are not full finite-state machines because they lack the ability to specify ilegal state transitions.
Ex: it should not be possible to transition from loaded to failed or vice-versa.
but being enable to instantiate a state unless you have valid values for all associated data is almost as good. 

Another way to deal with state: we can make isLoading a computed property of a struct 

struct StateStruct2 {
    var messages: [Message]?
    var error: Error?
    
    var isLoading: Bool {
        get { return messages == nil && error == nil }
        set { 
            messages = nil
            error = nil
        }
    }
}

Another alternative:

typealias State2 = Result<[Message], Error>? // it is not clear that nil stands for loading

### Model all app state as a enum - enums-as-state pattern

Usually an enum with lots of nested enums and structs that break the state down for individual subsystems.
The idea is to have a single variable that captures the program's state in its entirety.

All state changes go through this one variable that you can then observe (ex: by using didSet) to update your app's UI when a state change occurs.

This design makes its easy to write the entire app state to the disk and read it back on the next launch, essentially giving you state restoration for free.

More about it: [App Architecture](https://www.objc.io/books/app-architecture) 

You can start small by converting a single subsystem (ex: one view-controller) and see how it works.
Then gradually work your way up the hierarchy by wrapping your state enums for subsystems in a new enum that has one case per subsystem.

### Chossing between Enums and Structs

Example of a data type for an analytics event:

Enum option:

enum AnalyticsEvent {
    case loginFailed(reson: LoginFailureReason)
    case loginSucceeded
    .. // more cases.
}

extension AnalyticsEvent {
    var name: String {
        switch self {
            case .loginSucceeded:
                return "loginSucceeded"
            case .loginFailed:
                return "loginFailed"
            // ... more cases
        }
    }
    var metadata: [String: String] {
        switch self {
            // ...
        }
    }
}

Alternatively, we could model the same analytics event as a struct, storing its name and metadata in 2 properties.
We provide static methods (which correspond to the enums cases from above) to create instances for specific events.

struct AnalyticsEvent {
    let name: String
    let metadata: [String: String]
    
    private init(name: String, metadata: [String: String] = [:]) { // private init
        self.name = name
        self.metadata = metadata
    }
    
    static func loginFailed(reason: LoginFailedReason) -> AnalyticsEvent {
        return AnalyticsEvent(
            name: "loginFailed",
            metadata: ["reason": String(describing: reason)]
        )
    }
    
    static let loginSucceeded = AnalyticsEvent(name: "loginSucceeded")
    // ...
}


Distinct characteristics of each version:

* Struct depends on private init to prevent it to being extended. You can't add new cases to enums.
* Enum models the data more precisely. Struct can potentially represent an infinite number of values in 2 properties.
* Struct can have private "cases" (static methods or static properties not visible to clients). Enums case's have the same visibility as the enum itself.
* Adding an additional event type to the enum is a potentially source-breaking change for users of this API, whereas you can add static methods for new event types to the struct without affecting other code

### Paralles between Enums and Protocols

Enums and protocols can express "one of" relationships

ex:

enum Shape {
    case line(from: Point, to: Point)
    case rectangle(origin: Point, width: Double, height: Double)
    case circle(center: Point, radius: Double)
}

extension Shape {
    func render(into context: CGContext) {
        switch self {
            case let .line(from, to): // ...
            case let .rectangle(origin, width, height): // ...
            case let .circle(center, radius): // ...
        }
    }
}


Alternatively, we can use a protocol to define a shape as any type that can render itself into a Core Graphics context:

protocol Shape {
    func render(into context: CGContext)
}

struct Line: Shape {
    var from: Point
    var to: Point

    func render(into context: CGContext) { /*....*/ }
}   

* Enum-based implementation is grouped by methods: the CGContext rendering code for all types of shapes resides within a single switch statement in the render(into:) method
* Protocol-based is grouped by "cases": each concrete shape type implementats its own render(into:) method
* With the enum variant we can easily add new render methods (ex: render into SVG). However we can't add new kinds of shapes to the enum unless we control the source code containing the enum declaration. And it will be a source-breaking change for all methods that switch over the enum.
* We can easily add new kinds of shapes with the protocol variant: we just create a new struct and conform it to the Shape protocol. But we can't add new kinds of render methods without modifying the original Shape protocol. 
* Enums and protocols have complementary strenghts and weaknesses. Each solution is extensible in one dimension and lacks flexibility in the other. If you are writing a library, you should consider which dimension of extensibility is more important: new cases or new methods. 

Check https://talk.objc.io/episodes/S01E88-extensible-libraries-1-enums-vs-classes

### Use Enums to Model Recursive Data Structure

Recursive data structures: ex: data structures that "contain" themselves
Enums are perfect for modeling recursive data structures.
Think of a tree structure: multiple branches, each branch is another tree, which again branches into multiple subtrees

Many common data formats are tree structures: HTML, XML and JSON

Example of a singly linked list.
2 cases: 
* node with value and a reference to the next node
* end of the list

Either-or relation is a strong hint that a sum type is a good fit for defining a type for this data structure.

enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

### indirect keyword  

tells the compiler to represent the node case as a reference, and that makes the recursion work
enums are value types so them can't contain themselves. It would create an infinite recursion when calculating the type's size.
The compiler must be able to determine a fixed and finite size for each type. Treating the recursive case as a reference fixes this problem because the reference adds one more level of indirection.
Storage size for reference is always 8 bytes (on a 64-bit system).
indirect is available only for enums
É possivel utilizar o indirect na declaracao do enum, o que significa que estamos habilitando indirection para todos os associated values de todos os cases

Forma manual de criar esse indirect: 

It is less convenient to use since we'd have to perform manual boxing and unboxing all the time, but it is almost equivalent to the List type. 
Almost a List because the point of the indirection moved from the entire node case into the associated value's next element.
A fully identical solution would wrap the entire associated value in the box like this: case node(Box<(Element, next: BoxedList<Element>)>)

enum BoxedList<Element> {
    case end
    case node(Element, next: Box<BoxedList<Element>>)
}

final class Box<A> {
    var unbox: A
    init(_ value: A) { self.unbox = value }
}


Examplo uso da Linked List:

enum List<Element> {
    case end
    indirect case node(Element, next: List<Element>)
}

let emptyList = List<Int>.end
let oneElement = List.node(1, next: emptyList)

método helper para o (construct ou consing que é o nome tecnico de se adicionar um elemento no inicio da Linked List)

extension List {
    func cons(_ x: Element) -> List {
        return .node(x, next: self)
    }
}

// A 3-element list of 3,2,1
let list = List<Int>.end.const(1).cons(2).cons(3)

It is a bit ugly

Let's conform to ExpressibleByArrayLiteral to be able to initialize a list with an array literal.

extension List: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Element...) {
        self = elements.reversed().reduce(.end) { partialList, element in 
            partialList.cons(element)
        } // first reverses the input array (because lists are built from the end) and then uses reduce to prepend the elements to the list one by one starting with the .end node
    }
}

this list type is persistent. Nodes are immutable.
"Consing" another element onto the list doesn't copy the list. It just gives you a new node that links on to the front of the existing list.

This means that 2 lists can share a tail.

Still we can define mutating methods on List to push and pop elements.
These mutating methods don't change the list. They just change the part of the list the variables refer to.

extension List {
    mutating func push(_ x: Element) {
        self = self.cons(x)
    }
    
    mutating func pop() -> Element? {
        switch self {
            case .end return nil
            case let .node(x, next: tail): 
                self = tail
                return x
        }
    }
}

var stack: List<Int> = [3, 2, 1]
var a = stack
var b = stack

a.pop() // Optional(3)
stack.pop() //  Optional(3)
stack.push(4)
b.pop() // Optional(3)
b.pop() // Optional(2)
stack.pop() // Optional(4)
stack.pop() // Optional(2)  

The mutating methods allow us to change the value that self refers to. Yet the values themselves (nodes) are immutable.
In this sense, the variables have become interators into the list.

## Raw Values

Optional: declare a one-to-one mapping between an anum's cases and raw values

enum HTTPStatus: Int {
    case ok = 200
    case created = 201
    case movedPermanently = 301
    case notFound = 404
}

### The RawRepresentable Protocol

2 new APIs provided by RawRepresentable protocol automatically when enum has raw values: 

* a rawValue property
* failable initializer (init?(rawValue:))

 protocol RawRepresentable {
    associatedtype RawValue
    
    init?(rawValue: RawValue)
    var rawValue: RawValue { get }
}

ex: 

HTTPStatus(rawValue: 1000) // nil
HTTPStatus(rawValue: 404) // Optional(HTTPStatus.notFound)
HTTPStatus.created.rawValue // 201

### Manual RawRepresentable Conformance

Automatic RawValues work only for a limited set of types: String, Character, integer, floating-point
We can implement it manually for other types

enum AnchorPoint {
    case center
    case topLeft
    case topRight
    case bottomLeft
    case bottomRighgt
}

extension AnchorPoint: RawRepresentable {
    typealias RawValue = (x: Int, y: Int)
    
    var rawValue: (x: Int, y: Int) {
        switch self {
            case .center: return (0,0)
            case .topLeft: return (-1,1)
            case .topRight: return (1,1)
            case .bottomLeft: return (-1,-1)
            case .bottomRight: return (1,-1)
        }
    }
    
    init?(rawValue: (x: Int, y: Int)) {
        switch rawValue {
            case (0,0): self = .center
            case (-1,1): self = .topLeft
            case (1,1): self = .topRight
            case (-1, -1): self = .bottomLeft
            case (1, -1): self = .bottomRight
            default: return nil
        }
    }
}

AnchorPoint.topLeft.rawValue // (x: -1, y: 1)
AnchorPoint(rawValue: (x: 0, y: 0) // Optional(AnchorPoint.center)
AnchorPoint(rawValue: (x: 2, y: 1)) // nil

Manual implementation allows duplicate raw values for multiple enum cases. But it should be an exception.

### Raw Representable for Structs and Classes

We can conform structs or classes to RawRepresentable.
It is often a good choice for simple wrapper types that are introduced to preserve type safety.

Ex:  a user id type represented by a String: 

struct UserID: RawPresentable {
    var rawValue: String
}

In this case there's no need of a failable initializer. 
The compiler allows only the existance of the struct init.


### Enums and codable

Enum can be used as codable as well
https://www.swiftbysundell.com/articles/codable-synthesis-for-swift-enums/

### Internal Representation of Raw Values

No difference between raw values enums and all other enums (aside from RawRepresentable API and automatic Codable synthesis).

enum MenuItem: String {
    case undo = "Undo"
    case cut = "Cut"
    case copy = "Copy"
    case paste = "Paste"
}

MemoryLayout<MenuItem>.size // 1

RawValue nao adiciona mais espaco ao tipo. RawValue é como um computed property.

## Enumerating Enum Cases

CaseIterable protocol 

protocol CaseIterable {
    associatedtype allCases: Collections where allCases.Element == Self
    
    static var allCases: AllCases { get }
}

### CaseIterable em enum sem associatedtype

geracao de allCases é automatica
allCases é Collection
Podemos usar, por exemplo, count em allCases
MenuItem.allCases.count // 4

MenuItem.allCases.map { $0.rawValue } // ["Undo", "Cut", "Copy", "Paste" ]


The benefit of CaseIterable protocol is to automatically update when enum changes

A ordem do allCases é a ordem dos cases declarados

### Manual CaseIterable Conformance

Podemos implementar manualmente CaseIterable nao so em enums, mas tambem em Structs e Classes

exemplo para Bool:

extension Bool: CaseIterable {
    public static var allCases: [Bool] {
        return [false, true]
    }
}  

Bool.allCases // [false, true]

extension UInt8: CaseIterable {
    public static var allCases: ClosedRange<UInt8> {
        return .min....max
    }
}

UInt8.allCases.count // 256
UInt8.allCases.prefix(3) + UInt8.allCases.suffix(3) // [0, 1, 2, 253, 254, 255]

Suggestion: return a lazy Collection when implementing CaseIterable for a type with a lot of inhabitants

IMPORTANT: Both examples above ignore the general rule:

Don't conform types you don't own to protocols you don't own

## Frozen and Non-Frozen Enums

One of the best quality of an enum: ability to switch exhaustively over it.

2 scenarios:

1) Enums that are in the same module or are in different modules that are compiled together:
All possible cases are known at compile time. 

2) Enum is in a module that is linked into our program in binary form (ex: standard library)

Ex: Vamos supor que no nosso codigo precisamos fazer um switch sobre um enum do cenario 2 acima.
Pode acontecer de no futuro alguem rodar nosso codigo em uma versao diferente de iOS que esse enum tenha cases diferentes e ai nosso programa crasha.

### Non frozen enum

Enum that can gain new cases in the future. Best practice: add a @unknown case

switch error {
    case .dataCorrupted:
    
    @unknown default: // handle unknown cases
}

@unknown default gives you the best of both worlds: compile-time exhaustiveness checking and runtime safety

### Frozen enum

Developers promise never to add another case to the enum
It is an undocumented attribute @_frozen


### Resilience mode

Standard library and overlays are compiled in a special resilience mode, which is triggered by the -enable-resilience compiler flag.
Enums in resilient libraries are non-frozen by default

## Tips and tricks

* Avoid nested switch statements - prefer to use a tuple
    Ugly:
        switch isImportant {
            case true:
                switch isUrgent:
        }
        
    Better:
        switch (isImportant, isUrgent)

* Take advantage of definite initialization checks: 
    
        let priority: Int
        switch (isImportant, isUrgent) { // It will emit an error if we forget to initialize in one or more code paths
            case (true, true: priority = 3
            case (true, false): priority = 2
            case (false, true): priority = 1
            case (false, false): priority = 0
        }

    Switch is a statement like if, not an expression.
    
* Avoid naming enum cases none or some: Potential clash with Optional's case names
* Use backsticks for case names that are reserved words: ex: case `default`
* Enum cases can be used like factory methods: 

    ex: 
        enum OpaqueColor {
            case rgb(red: Float, green: Float, blue: Float)
            case gray(intensity: Float)
        }
        
        OpaqueColor.rgb // (Float, Float, Float) -> OpaqueColor
        
        let gradient = stride(from: 0.0, through: 1.0, by: 0.25).map(OpaqueColor.gray)
        
* Don't use associated values to fake stored properties. Use a struct instead.
    Enums can't have stored properties
    
    ex:
        enum AlphaColor { // this works, but extracting alpha amount from an AlphaColor isn't very convenient now
            case rgba(red: Float, green: Float, blue: Float, alpha: Float)
            case gray(intensity: Float, alpha: Float)
        }

        better:
        
        struct Color {
            var color: OpaqueColor
            var alpha: Float
        }

    💡 When a enum has the same piece of data in its payload, consider wrapping the enum in a struct and pulling the common property out. It is like algebra: a * b + a * c = a * (b + c) // term sum and product types is "algebraic data type"

* Don't overdo it with associated value components. - In production it is better to write a custom struct for each case. Structs can 

    ex: enum Shape {
            case line(Line)
            case rectangle(Rectangle)
            case circle(Circle)
        }
        
        struct Line {
            var from: Point
            var to: Point
        }
        
        struct Rectangle {
            var origin: Point
            var width: Double
            var height: Double
        }

        struct Circle {
            var center: Point
            var radius: Double
        }

* Use caseless enums as namespaces - We can use enums as "fake" namespaces.
    Since type definitions can be nested, outer types act as namespaces fot all declarations they contain.
    Enums that have no cases (ex: Never) can't be instantiated. The standard library does this too with Unicode
    
    /// A namespace for Unicode utilities
    
    public enum Unicode {
        public struct Scalar {
            internal var _value: UInt32
            // ...
        }
        // ...
    }

    ‼️ protocols can't be nested inside other declarations. That why in standard library we have UnicodeCodec rather than Unicode.Codec
