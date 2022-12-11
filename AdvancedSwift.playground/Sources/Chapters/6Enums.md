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

Alternatively, we could model the same analytics event as a struct, storing its name and metadata in 2 
