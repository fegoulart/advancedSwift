# 4 FUNCTIONS

## THREE-LEGGED STOOL (3 coisas mais importantes que temos que entender sobre funções)

1. Functions can be assigned to variables and passed in and out of other functions as arguments, just as an Int or a String can be
2. Functions can capture variables that exist outside of their local scope
3. There are two ways of creating functions:
* func keyword
* closure expressions:  { }

## FIRST-CLASS OBJECTS

É o conceito mais importante a se entender em programação funcional:
É basicamente o item 1 acima.

### Exemplo 1

func printIt(i: Int) {
    print("You passed \(i).")
}

let funVar = printIt

funVar(2) // You passed 2.

### Exemplo 2

func useFunction(function: (Int) -> ()) {
    function(3)
}

useFunction(function: printIt) // You passed 3.
useFunction(function: funVar) // You passed 3.

### Exemplo 3

func returnFunc() -> (Int) -> String {
    func innerFunc(i: Int) -> String {
        return "You passed \(i)."
    }
    return innerFunc
}

let myFunc = returnFunc()
myFunc(3) // You passed 3.

## Functions can capture values that exist outside of their local scope

Variables referenced by functions are captured and stick around. (Are not destroyed).

### Exemplo 1

func counterFunc() -> (Int) -> String {
    var counter = 0
    func innerFunc(i: Int) -> String {
        counter += i
        return "Running total: \(counter)"
    }
    return innerFunc
}

Theses functions combined with their captured variables are similar to instances of classes with a single method (the function) and some member variables (the captured variables)

## Functions can be declared using the {} syntax for closure expressions 

Two ways to define function

* func
* {}

func doubler(i: Int) -> Int {
    return i * 2
}

[1, 2, 3, 4].map(doubler) // [2, 4, 6, 8]

let doublerAlt = { (i: Int) -> Int in 
    return i * 2
}
[1, 2, 3, 4].map(doublerAlt) // [2, 4, 6, 8]

Closure expression is anonymous

### Function literal

1 is an integer literal
"hello" is a string literal
a closure expression is a function literal

### Closure functional programming style

* no need to be stored in a variable if you are only using to pass it as an argument. [1, 2, 3].map( { (i: Int) -> Int in return i * 2 })
* if the compiler can infer a type from context, no need to specify it. [1, 2, 3].map( { i in return i * 2 })
* if closure body has only one single expression, no need to use return keyword. [1, 2, 3].map( { i in i * 2 })
* automatic shorthand names for arguments: $0, $1. [1, 2, 3].map( { $0 * 2 })
* trailing closure syntax: if closure is last argument, it can be moved to outside the parenthesis. [1, 2, 3].map() { $0 * 2 }
* if closure is the only parameter of a function, no need to use parenthesis. [1, 2, 3].map { $0 * 2 }

### Supplying the context

* inside closure expression. let isEvenAlt = { (i: Int8) -> Bool in i % 2 == 0 }
* outside closure expression. let isEvenAlt2: (Int8) -> Bool = { $0 % 2 == 0 }. let isEvenAlt3 = { $0 % 2 == 0 } as (Int8) -> Bool

### Generics

* generic isEven that works on any integer as a computed property

extension BinaryInteger {
    var isEven: Bool { return self % 2 == 0 }
}

* isEven variant for all Integer types as a free function. A variable can't hold a generic function, only a specific one.

func isEven<T: BinaryInteger>(_ i: T) -> Bool {
    return i % 2 == 0
}
let int8IsEven: (Int8) -> Bool = isEven


## High-Order Functions

Function that takes functions as argument and apply them in useful ways

### Closure != Closure Expression

* Closure is a function combined with any captured variables. A closure can be written with func or with {} (example: let f = counterFunc() - f is a closure)
* Closure expression: { }

Closure written with function

func travel() -> (String) -> Void {
    var counter = 1

    return {
        print("\(counter). I'm going to \($0)")
        counter += 1
    }
}

## Flexibility through Functions

Four sort methods:

* non-mutating variant: sorted(by:) - Sorted is available when element conforms to Comparable
* non-mutating variant: sorted()
* mutating variant: sort(by:) - Element conforms to RandomAccessCollection.
* mutating variant: sort(by:)

RandomAccessCollection protocol: it doesn't offer new primary functions, but it defines the requirements for the complexity of working with indices; calculating the distance between the indices and getting the index at some distance from the given one must be implemented with complexity O(1)

We can choose different protocols to create our custom collection.
1. Sequence
2. Collection
3. BidirectionalCollection
4. RandomAccessCollection

[Article](https://hackernoon.com/on-the-way-from-sequence-to-randomaccesscollection-in-swift)

### Function as arguments and treating functions as data

Can be used to replicate Objective-C functionality (selectors, dynamic dispatch) that make use of Objective-C's dynamic nature 

Essa parte acabei pulando pois parecia mais voltada para quem tem conhecimento em objc

## Function as Data

Ainda pensando em ordenaçao, let's define a generic type alias to describe sort descriptors

typealias SortDescriptor<Root> = (Root, Root) -> Bool // true se tiver ordenado, false se nao

exemplo de uso:

let sortByYear: SortDescriptor<Person> = { $0.yearOfBirth < $1.yearOfBirth }
let sortByLastName: SortDescriptor<Person> = {
    $0.last.localizedStandardCompare($1.last) == .orderAscending
}

Do jeito que está acima, teriamos que ficar criando esses descriptors um por um. Ou usando copy paste.

E se tivessemos uma funcão de gerar função ? 
2 Inputs:

* key: (Root) -> Value
* areInIncreasingOrder: (Value, Value) -> Bool

Output:

* typealias SortDescriptor<Root> = (Root, Root) -> Bool) ? // Primeiro Root seria $0 e segundo Root $1

func sortDescriptor<Root, Value>(
    key: @escaping(Root) -> Value, // describes how to drill down into an element of type Root and extract the value of type Value that is relevant for one particular sorting step
    by areInIncreasingOrder: @escaping (Value, Value) -> Bool
    ) -> SortDescriptor<Root> {
    return { areInIncreasingOrder(key($0), key($1)) }
}

let sortByYearAlt: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth }, by: <)

people.sorted(by: sortByYearAlt)

func sortDescriptor<Root, Value>( // Overlooad para qquer comparable 
    key: @escaping (Root) -> Value
) -> SortDescriptor<Root> where Value: Comparable {
    return { key($0) < key($1) }
}

Agora com um parametro para definir o criterio de ordenacao:

func sortDescriptor<Root, Value>(
    key: @escaping (Root) -> Value,
    ascending: Bool = true,
    by comparator: @escaping (Value) -> (Value) -> ComparisonResult
) -> SortDescriptor<Root> {
    return { lhs, rhs in
        let order: ComparisonResult = ascending ? .orderedAscending : .orderedDescending
        return comparator(key(lhs))(key(rhs)) == order
    }
}

O nosso SortDescriptor é tao expressivo quanto o NSSortDescriptor do ObjectiveC. Mas é ainda melhor porque é type safe e nao depende de runtime programming

Se quisermos implementar um uso de multiplos SortDescriptors:

func combine<Root>(sortDescriptors: [SortDescriptor<Root>]) -> SortDescriptor<Root> {
    return { lhs, rhs in
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder(lhs, rhs) { return true }
            if areInIncreasingOrder(rhs, lhs) { return false }
        }
        return false
    }
}

let combined: SortDescriptor<Person> = combine(sortDescriptors: [sortByLastName, sortByFirstName, sortByYearAlt2])
people.sorted(by: combined)

One drawback of the function-based approach is that functions are opaque.
We can take an NSSortDescriptor (objc) and print it to the console and we get some information about the sort descriptor: the key path, the selector name, and the sort order.
But our function-based approach can't do this. If it's important to have that information, we could wrap the function in a struct or class and store additional debug information.

Using functions as data: storing them in arrays and building those arrays in runtime opens up a new level of dynamic behavior. That is one way in which statically typed compile-time-oriented language like Swift can still replicate some of the dynamic behavior of languages like Objective-C or Ruby.

Combine functions is one of the building blocks of functional programming.

### Writing custom operator to combine 2 sort functions

Most of the time, writing a custom operator is a bad idea. Custom operators are often hard to read than functions are, because operators don't have self-explanatory names.
However they can be very powerful when used sparingly.
Unless you're writing highly domain-specific code, a custom operator is probably overkill.

infix operator <||>: LogicalDisjunctionPrecedence
func <||><A>(
    lhs: @escaping (A,A) -> Bool,
    rhs: @escaping (A,A) -> Bool
) -> (A,A) -> Bool {
    return { x, y in
        if lhs(x,y) { return true }
        if lhs(y,x) { return false }
        // Otherwise they're the same, so we check for the second operator
        if rhs(x,y) { return true }
        return false
    }
}

let combinedAlt = sortByLastName <||> sortByFirstName <||> sortByYearAlt
people.sorted(by: combinedAlt)

### Optionals

func lift<A>(
    _ compare: @escaping (A) -> (A) -> ComparisonResult
) -> (A?) -> (A?) -> ComparisonResult {
    return { lhs in { rhs in
        switch (lhs, rhs) {
        case (nil, nil): return .orderedSame
        case (nil, _): return .orderedAscending
        case (_, nil): return .orderedDescending
        case let (l?, r?): return compare(l)(r)
        }
    }}
}

let compare = lift(String.localizedStandardCompare)
let result = files.sorted(by : sortDescriptor(key: { $0.fileExtension }, by: compare))
result // "one", "file.c", "file.h", "test.h"

## Functions as Delegates

### What is delegate

It is the use of protocols for callback.
You define a protocol. Your owner implements that protocol and it registers itself as your delegate so that it gets callbacks.

If a delegate protocol contains only a single method, you can mechanically replace the property storing the delegate object with one that stores the callback function directly.
However, there are a number of tradeoffs to keep in mind.

## Delegates, Cocoa Style

Creating a protocol in the same way Cocoa defines its countless delegate protocols.

protocol AlertViewDelegate: AnyObject { // class only protocol because we want our AlertView to hold a weak reference to the delegate (no worries about Reference Cycles). 
    func buttonTapped(atIndex: Int)
}  

class AlertView {
    var buttons: [String]
    weak var delegate: AlertViewDelegate? //Convention to mark delegate as weak
    
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}


class ViewController: AlertViewDelegate {
    let alert: AlertView
    
    init() {
        alert = AlertView(buttons: ["OK", "Cancel")
        alert.delegate = self
    }
    
    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}

## Delegates that work with Structs

### Same approach won't work

Implementing previous example in a struct

protocol AlertViewDelegate { // nao pode ser class only
    mutating func buttonTapped(atIndex index: Int)
}

class AlertView {
    var buttons: [String]
    var delegate: AlertViewDelegate? // delegate property can no longer be weak

    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }

    func fire() {
        delegate?.buttonTapped(atIndex: 1)
    }
}

struct TapLogger: AlertViewDelegate {
    var taps: [Int] = []
    mutating func buttonTapped(atIndex index: Int) {
        taps.append(index)
    }
}
let alert = AlertView()
var logger = TapLogger()
alert.delegate = logger
alert.fire()
print(logger.taps) // []

Problem: if we look at logger.taps after an event is fired, the array is still empty

When using structs, the original value doesn't get mutated
Important: Delegate protocols don't make sense when using structs !!!!!

## Functions instead of Delegates

class AlertView {
    var buttons: [String]
    var buttonTapped: ((_ buttonIndex: Int) -> Void)?
    
    init(buttons: [String] = ["OK", "Cancel"]) {
        self.buttons = buttons
    }
    
    func fire() {
        buttonTapped?(1)
    }
}

struct TapLogger {
    var taps: [Int] = []
    
    mutating func logTap(index: Int) {
        taps.append(index)
    }
}

let alert = AlertView()
var logger = TapLogger()
alert.buttonTapped = logger.logTap // Error. It's not clear what should happen in the assignment. Does the logger get copied ? Or should buttonTapped mutate the original variable (i.e. logger gets captured) ?
alert.buttonTapped = { logger.logTap(index: $0) } // We are capturing the original logger variable (not the value) and that's we're mutating it. Additional benefit: naming is now decoupled: callback property is called buttonTapped but the function that implements it is called logTap

alert.buttonTapped = { print("Button \($0) was tapped") } // Anonymous function variant

### Caveats when combining callback with classes / Memory management

class ViewController { 
    let alert: AlertView
    
    init() {
        alert = AlertView(buttons: ["OK", "Cancel"])
        alert.buttonsTapped = self.buttonTapped(atIndex:) // Assign its own function as alertView callback handler
        // PROBLEM: We are creating here a reference cycle
        // How to solve it:
        alert.buttonsTapped = { [weak self] index in  // or [unowned self]
            self?.buttonTapped(atIndex: index)
        }
        
    }
    
    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}

### Function types parameter names

Em alert view temos 

var buttonTapped: ((_ buttonIndex: Int) -> Void)?

O Swift nao permite colocarmos nomes nos parametros, mas podemos pelo menos para documentacao incluirmos _ nome

### Tradeoffs (Delegate vs Callback functions)

Beneficios do delegate com protocol:

* É mais facil de impedir reference cycles (por causa do pattern class-only protocol with weak delegate)
* Agrupa melhor no caso de multiplos callbacks
* Fácil de fazer um "unregister": só atribuir nil ao delegate

Contras do delegate com protocol:
* Verbosity
* Single type has to implement all the methods

Benefícios do callback functions
* Flexibility - allows to use structs and anonymous functions

Contra do function as delegate
* Can introduce reference cycles
* Funcoes nao podem ser comparadas, então se precisar de uma lista ou array de delegates, fica dificil por exemplo encontrar a funcao correta para remover (para fazer um unregister)

## inout parameters and mutating methods

for inout parameters we can only pass lvalues
it doesn't make sense mutate a rvalue

### & is not pass by reference

& is pass-by-value-and-copy-back
The compiler may optimize an inout variable to pass-by-reference but we shouldn't rely on this behavior.

### lvalues vs rvalues

#### lvalue

* describes a memory location. 
* short for left value
* expressions that can appear on the left side of an assignment
* variables defined using let cannot be used as lvalue
* arrays subscript (ex: array[0]) can be lvalue (if array is defined with var)
* all subscripts that have defined get and set can be lvalues 

#### rvalue

* describes a value

### Example

func increment(value: inout Int) {
    value += 1
}
  
var i = 0 // if we define with let an Error will appear 
increment(value: &i)

#### read-only property: Error

struct Point {
    var x: Int
    var y: Int
}

extension Point {
    var squaredDistance: Int {
        return x*x + y*y
    }
}

increment(value: &point.squaredDistance) // Error

### Inout with operators

Doesn't need & (ampersand)

postfix func ++(x: inout Int) {
    x += 1
}

point.x++

#### mutating operator combined with optional chaining

var dictionary = ["one": 1]
dictionary["one"]?++
dictionary["one"] //Optional(2)

## Nested Functions and inout

We are not allowed to let inout parameter escape
Faz sentido pq como o inout deve ser copiado de volta no final da execução, se o compilador nao souber quando e onde sera a execucao, como ele saberá como fazer esse copy-back ?

#### Happy path

func incrementTenTimes(value: inout Int) {
    func inc() {
        value += 1
    }
    for _ in 0..<10 {
        inc()
    }
} 

var x = 0
incrementTenTimes(value: &x)
x // 10

#### Escape and error

func escapeIncrementValue(value: inout Int) -> (Void) -> () {
    func inc() {
        value += 1
    }
    return inc // ERROR: NESTED FUNCTION CANNOT CAPTURE INOUT PARAMETER AND ESCAPE
}

## When & Doesn't Mean inout

Other meaning of &:

* converting a function argument to an unsafe pointer 

Here you are really passing by reference (pointer)

Ex: pass a var as an UnsafeMutablePointer parameter

### Example

func incref(pointer: UnsafeMutablePointer<Int>) -> () -> Int {
    // Store a copy of the pointer in a closure
    return {
        pointer.pointee += 1
        return pointer.pointee
    }
}

Swift arrays decay to pointers to make C interoperability nice and painless.

Problem: suppose you pass in an array that goes out of scope before you call the resulting function:

let fun: () -> Int
do {
    var array = [0]
    func = incref(pointer: &array)
}
fun()

This opens up an exciting world of undefined behavior

### Moral here

Know what you're passing in to
with & you could be invoking nice safe inout semantics or casting a poor variable into the brutal world of unsafe pointers
To deal with unsafe pointers we need to be very careful about the lifetime of variables

## Properties 

2 special kinds of methods:

* computed properties - don't use memory to store values - Value is computed on the fly every time property is accessed. It is really a method with unusual calling and defining conventions
* subscripts

### Various ways to define properties

struct GPSTrack {
    private(set) var record: [(CLLocation, Date)] = []
}

extension GPSTrack {
    /// Returns all the timestamps for the GPS track.
    /// - Complexity: O(*n*), where *n* is the number of points recorded
    var timestamps: [Date] {
        return record.map { $0.1 }
    }
}

As we didn't specify a setter, the timestamps property is read only.
The result isn't cached. It is computed every time is accessed.

The Swift API Guideline suggests that we document every computed property that is not O(1), because callers might assume it is always O(1).

### Change observers

Handlers that are called every time a property is set (even if value doesn't change):

* willSet
* didSet

Useful when working with Interface Builder to know when a IBOutlet gets connected (didSet) and then perform additional configuration in the handler.
Ex:

class SettingsController: UIViewController {
    @IBOutlet weak var label: UILabel? {
        didSet {
            label?.textColor = .black
        }
    }
}

Observers have to be defined at the declaration site of a property. Can't be added retroactively in an extension.
It is a tool for the designer of the type, not the user.

willSet and didSet handlers are shorthand for defining a pair of properties:

1. One private stored property that provides the storage
2. One public computed property whose setter performs additional work before and/or after storing the value in the stored property

This is fundamentally different from the key-value observing mechanism in Foundation, which is often used by consumers of an object to observe internal changes, whether or not the class's designer intended this.

You can however override a property in a subclass to add an observer.
ex:

class Robot {
    enum State {
        case stopped, movingForward, turningRight, turningLeft
    }
    var state = State.stopped
}

class ObservableRobot: Robot {
    override var state: State {
        willSet {
            print("Transitioning from \(state) to \(newValue)"
        }
    }
}

var robot = ObservableRobot()
robot.state = .movingForward

Property observing in Swift is a purely compile-time feature. KVO in other hand uses the Objective-C runtime to dynamically add an observer to a class's setter.

### Lazy stored values

lazy property must always be declared as var because its initial value might not be set until after initialization complets

Swift has a strict rule that let constants must have a value before an instance's initialization complets

lazy is a very specific form of memoization

example: a lazy UIImage property can defer the expensive generation of the image until the property is accessed for the first time

Lazy property is a closure expression that returns the value we want to store

lazy var preview: UIImage = {
    for point in track.record {
        // Do some expensive computation
    }
    return UIImage(/*...*/)
}  

It is executed the first time it is accessed (note the parenthesis at the end)

Unlike computed properties, stored properties and stored lazy properties can't be defined in an extension.

struct Point {
    var x: Double
    var y: Double
    private(set) lazy var distanceFromOrigin: Double = (x*x + y*y).squareRoot() ---> É um erro isso ser lazy pq só executa uma vez e nao atualiza mais
    
    init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

var point = Point(x: 3, y: 4)
point.distanceFromOrigin // 5.0
point.x += 10
point.distanceFromOrigin // 5.0 ----> CUIDADO, lazy property não atualiza automaticamente

let immutablePoint = Point(x: 3, y: 4) ---> precisa ser var para usar lazy
immutable.distanceFromPoint // ERRO - Cannot use mutating getter on immutable value

Accessing a lazy property must potentially mutate its container.

lazy properties is often a bad fit for structs (because users cannot use let)

lazy keyword doesn't perform any thread synchronization. 

IF MULTIPLE THREADS ACCESS A LAZY PROPERTY AT THE SAME TIME BEFORE THE VALUE HAS BEEN COMPUTED, IT'S POSSIBLE THE COMPUTATION COULD BE PERFORMED MORE THAN ONCE, ALONG WITH ANY SIDE-EFFECTS THE COMPUTATION MAY HAVE.

## SUBSCRIPTS

It's like a hybrid of functions and computed properties, with their own special syntax

### It is like functions

* Take arguments as functions
* We can overload them by providing multiple variants with different types. ex:

let fibs = [0, 1, 1, 2, 3, 5]
let first = fibs[0] // 0
fibs[1..<3] // [1,1]

### It is like computed properties

* Can be read-only (using get) or read-write (using get set) like computed properties

### Custom subscripts

Add subscripting to our own type
Extend existing types with new subscripts

ex: the caller can pass zero or more comma-separated values of the specified type (collection index)
parameters are available inside the function as an array

extension Collection {
    subscript(indices indexList:Index...) -> [Element] { // Three dots is a variadic parameter
        var result: [Element] = []
        for index in indexList {
            result.append(self[index])
        }
        return result
    }
}

Array("abcdefghijklmnopqrstuvwxyz")[indices: 7,4,11,11,14] // ["h", "e", "l", "l", "o"]

### Advanced subscripts

Subscripts aren't limited to a single parameter
Dictionary is a subscript that takes more than one parameter

Subscripts can also be generic in their parameters or their return type

Consider a heterogeneus dictionary of type [String: Any]

var japan: [String: Any]: [
    "name": "Japan",
    "capital": "Tokyo",
    "population": 126_440_000,
    "coordinates": [
        "latitude": 35.0,
        "longitude": 139.0
    ]
]

it isn't easy to mutate a nested value

japan["coordinates"]?["latitude"] = 36.0 // ERROR: Type 'Any' has no subscript members

(japan["coordinate"] as? [String: Double])?["latitude"] = 36.0 // ERROR: Cannot assign to immutable expression

You can mutate a variable through a typecast
You would have to store the nested dictionary in a local variable first, then mutate that variable
and then assign the local variable back to the top-level key

Dictionary extension with generic subscript that takes the desired type as a second parameter and attempst the cast inside the subscript implementation

extension Dictionary {
    subscript<Result>(key: Key, as type: Result.Type) -> Result? {
        get {
            return self[key] as? Result
        }
        set {
            // Delete existing value if caller passed nil
            guard let value = newValue else {
                self[key] = nil
                return
            }
            // ignore if types don't match
            guard let value2 = value as? Value else {
                return
            }
            self[key] = value2
        }   
    }
}

japan["coordinates", as: [String:Double].self]?["latitude"] = 36.0
japan["coordinates"] // Optional(["latitude": 36.0, "longitude": 139.0])

it's nice that generic subscripts make this possible, but you'll notice the final syntax is quite ugly.

Swift is not well suited for working on heterogeneous collections like this dictionary.

In most cases, it's better to define a custom struct type and conform it to Codable for converting value to and from transfer formats

## Key Paths

Key path is an uninvoked reference to a property
Analog to an unapplied method reference

Previously it wasn't possible to refer to a type's property (String.count, String.uppercased)

Key path expression start with a backslash: \String.count

The backslash is necessary to distinguish a key path from a type property of the same name that may exist

Type inference works with key path: /.count

Key paths and function types references are so closely related but Swift has different syntaxes for them.

Key path describes a path through a value hierarchy starting at root value.

struct Address {
    var street: String
    var city: String
    var zipCode: Int
}

struct Person {
    let name: String // immutable so keyPath is not Writable
    var address: Address
}

let streeKeyPath = \Person.address.street // Swift.WritableKeyPath<Person, Swift.String>
let nameKeyPath = \Person.name // Swift.KeyPath<Person, Swift.String>

Key paths can be composed of any combination of stored and computed properties, along with optional chaining operators.

let simpsonResidence = Address(street: "1094 Evergreen Terrace", city: "Springfield", zipCode: 97475)
var lisa = Person(name: "Lisa Simpson", address: simpsonResidence)
lisa[keyPath: nameKeyPath] // Lisa Simpson
lisa[keyPath: streetKeyPath] = "742 Evergreen Terrace"

lisa[keyPath: name] = "Bart" // Error - Immutable

Key paths can descript subscripts too (not only properties):

var bart = Person(name: "Bart Simpson", address: simpsonResidence)
let people = [lisa, bart]
people[keyPath: \.[1].name] // Bart Simpson

### Key Paths modeled with functions

Key path that map a base type Root to a property of type Value is very similar to a function of type (Root) -> Value or for writable key paths, a pair of functions for both getting and setting a value.

Key paths are values - that is the major benefit they have over functions.

You can test them for equality and use them as dictionary keys (they conform to hashable) and you can be sure that a key path is stateless, unlike fucntions, which might capture mutable state. 

Key paths are composable by appending one key path to another. Notice that the types must match: if you start with a key path from A to B, the key path you append must have a root type of B, and the resulting key path will then map from A to the appended key path's value type, say C:

// KeyPath<Person, String> + KeyPath<String, Int> = KeyPath<Person, Int>
let nameCountKeyPath = nameKeyPath.appending(path: \.count) 
// Swift.KeyPath<Person, Swift.Int>

Rewriting sort descriptoes from earlier in this chapter to use key paths instead of functions:

typealias SortDescriptor<Root> = (Root, Root) -> Bool

func sortDescriptor<Root, Value>(key: @escaping (Root) -> Value) -> SortDescriptor<Root> where Value: Comparable {
    return { key($0) < key($1) }
}

