# 3 OPTIONALS

## SENTINEL VALUES

Sentinel values are magic values that indicate that the function hasn't returned a real value.
E.g. returning -1 meaning that the function could not return a valid Int

## BILLION-DOLLAR MISTAKE

Tony Hoare created in 1965 the null references. He calls them his billion-dollar mistake

## REPLACING SENTINEL VALUES WITH ENUMS

enum Optional<Wrapped> {
    case none
    case some(Wrapped)
}

### enum pattern matching

var array = ["one", "two", "three"]
switch array.index(of: four) {
    case .some(let idx):
        array.remove(at: idx)
    case .none:
        break
}

### if let

var array = ["one", "two", "three"]
if let idx = array.index(of: "four") {
    array.remove(at: idx)
}

#### try?

try? converts error in optional 

if let data = try? Data(contentsOf: url) {

}

### while let

loop that terminates when its condition returns nil
It is ideal for iterator

while let line = readLine(), !line.isEmpty {
    print(line)
}

#### iterator

Sequence protocol provides an iterator

let array = [1, 2, 3]
var iterator = array.makeIterator()
while let i = iterator.next() {
    print(i, terminator: " ")
}

#### for loops are just like while loops. They also support Boolean clauses

but here the boolean clause doesn't stop execution. It is just a filter

for i in 0..<10 where i%2 == 0 {
    print(i, terminator:" ")
} // 0 2 4 6 8

rewriting the above code using while let

var iterator2 = (0..<10).makeIterator()
while let i = iterator2.next() {
    guard i % 2 == 0 else { continue }
    print(i)
}

## DOUBLY NESTED OPTIONALS

The type an optional wraps can itself be optional

let stringNumbers = ["1", "2", "three"]
let maybeInts: [Int?] = stringNumbers.map { Int($0) } // [Optional(1), Optional(2), nil]

Int.init(String) returns Int?

iterator.next() wraps each element inside an optional

var iterator = maybeInts.makeIterator()
while let maybeInt = iterator.next() {
    print(maybeInt, terminator: " ")
}
// Optional(1) Optional(2) nil ---> Aqui vai acabar imprimindo nil pq nesse caso, iterator.next() era .some(nil)

### for case let

com for case let é possivel trazer só os valores não nulos

for case let i? in maybeInts {
    // i will be an Int not an Int?
    print(i, terminator: " ")
}
// 1 2

para trazer só os nulos

for case nil in maybeInts {
    // Will run once for each nil
}

### x? pattern

x2 is shorthand for .some(x)

for case let .some(i) in maybeInts { // for case i? in maybeInts
    print(i)
}

### case based pattern matching (if / for / while case)

Can be used with non optional as well

let j = 5
if case 0..<10 = j { // if case is equivalent to switch j { case let 5: ...
    print("\(j) within range")
} 
// 5 within range

### if var and while var

let number = "1"
if var i = Int(number) {
    i += 1
    print(i)
} // 2

Optionals are value types and unwrapping them copies the value inside

## SCOPING OF UNWRAPPED OPTIONALS

guard let else { return }

else block must leave current scope:

* return
* throwing an error
* calling fatalError (or any other function that returns Never) 
* break / continue (if the guard is in a loop)

## Never vs nil vs Void

Swift makes a careful distinction between the absence of a thing (nil), presence of nothing (Void) and a thing which cannot be (Never) - David Smith wwww.twitter.com/Catfish_Man/

A function that return type Never signals to the compiler that it will never return
2 common types of functions that do this:
    * Abort the program: fatalError
    * Run for the entire lifetime of the program: dispatchMain
Else branch of guard must either exit the current scope or call one of these never-returning functions

Never is what's called an uninhabited type (type that has no valid values and thus can't be constructed)
Never is usefull in combination with Result in generic contexts Result<..., Never> means it will never fail (Never is impossible to construct).
Function declared to return an uninhabited type can never return normally.

public enum Never {} // no cases

one use case for Never:

func unimplemented() -> Never {
    fatalError("This code path is not implemented yet.")
}
    
Void: 

public typealias Void = ()

Void use cases: 

* types of functions that don't return anything
* Observable<Void> ---> event with no payload

## Optional Chaining

delegate?.callback() 
resultado será sempre opcional

we can chain calls on optional values

let lower = str?.uppercased().lowercased()

We don't need a ? after uppercased because optional chaining is a flattening operation (returns a single optional and not optional optional)
That's because uppercased returns a String and not an optional.

a? = 10 ---> It will assign 10 to a just if a is not nil

# nil coalescing operator ??

when we want to have a default value when nil
It is better to use ?? than ternary

whenever you find yourself guarding a statement with a check to make sure the statement is valid, it's a good sign optionals would be a better solution'

a ?? b ?? c (chaining) is different from (a ?? b) ?? c (unwrapping the inner first and then the outer layers)

?? uses short circuiting: right side of the operator is only evaluated when left-hand side is nil (it uses autoclosure)

## Optionals with string interpolation

You should never use optionals directly in user-facing strings and always unwrap them first

To use ?? both sides must match Double? ?? needs a Double

new operator to use for debbugging and logging optionals: ???

## Optional map

We can treat optional as a collection of either zero or one values

extension Optional {
    func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let value = self else { return nil}
        return transform(value)
    }
}

## Optional flatMap ( result will be just one optional, not doubly)

scenario: we want to perform a map on an optional value but the transformation function also has an optional result. We will end up with a doubly nested optional

ex: we want to fetch the first element of an array of strings as a number, using first on the array and then map to convert it to a number

let stringNumbers = ["1", "2", "3", "foo"]
let x = stringNumbers.first.map { Int($0) } // Optional(Optional(1)) 

let y = stringNumbers.first.flatMap { Int($0) } // Optional(1)

Important: We can achieve the same if let short circuit with flatMap

if let a = stringNumbers.first, let b = Int(a) { 
    print(b)
}  // 1

## Compact Map

it filters out nil and unwraps the non-nil values

numbers.compactMap { Int($0) }.reduce(0, +) // 6

## Equating Optionals

Optional conforms to Equatable only if Wrapped type also conforms to Equatable

Whenever we have a non-optional value, Swift will always be willing to promote it to an optional value in order to make they type match

Ou seja, podemos comparar valores opcionais com não opcionais sem nos preocuparmos em desenvelopar

## Using optionals in dictionaries

When we set a value to nil, it removes the key

var dictWithNils: [String: Int?] = [
    "one": 1,
    "two": 2,
    "none": nil
]

dictWithNils["two"] = nil // Will remove this key and not update it

Other ways to change value to nil:

dictWithNils["two"] = Optional(nil)
dictWithNils["two"] = .some(nil)
dictWithNils["two"]? = nil

## Comparing Optionals

Inequality operators were removed for optionals in Swift 3

It will not work:

let temps = ["-479.67", "98.6", "warm"]
let belowFreezing = temps.filter { Double($0) < 0 }

## WHEN TO FORCE UNWRAPS

Different opinions:

* never
* whenever it makes the code clearer
* when you can't avoid

Recomendacao do livro:

Use ! when you're so certain that a value won't be nil that you want your program to crash if it ever is
But theses cases are pretty rare

ex:

extension Sequence {
    func compactMap<B>(_ transform: (Element) -> B?) -> [B] {
        return lazy.map(transform).filter { $0 != nil }.map { $0! }
    }
}

Better option: Whenever you do find yourself reaching for !, it's worth taking a step back and wondering if there really is no other option

let ages = [
    "Tim": 53, 
    "Angela": 54,
    "Craig": 44,
    "Jony": 47,
    "Chris": 37,
    "Michael": 34
]

ages.keys
    .fiter { name in ages[name]! < 50 } // since all the keys came from the dict, there's no missing key
    .sorted() // ["Chris", "Craig", "Jony", "Michael"]

Forma mais bonita:

ages.filter { (_,age) in age < 50 }
    .map { (name, _) in name }
    .sorted() // ["Chris", "Craig", "Jony", "Michael"]
    
O livro tambem prefere que vc utilize ! quando vc está seguro que o valor optional que chegará terá valor. Isso para nao varrer situacoes teoricamente impossiveis para debaixo do sofá.

## Improving Force-Unwrap Error Messages

Novo operador !!

let s = "foo"
let i = Int(s) !! "Expecting integer, got \"\(s)\"" 

## Asserting in Debug Builds

Novo operador !? (assert para debug e valor default em release)

Int(s3) !? (5, "Expected integer")

## 3 ways halt execution

There are 3 ways to halt execution:

* fatalError
* assert (debug)
* precondition (similar ao assert, mas funciona tb em release)

## Implicitly Unwrapped Optionals

Two reasons to use !:

1. Objective-C interoperability: call an objc API or been called from an obj API. Attention: You should never see a pure Swift API returning ! or passing ! into a callback
2. When a value is nil very briefly, for a well-defined period of time, and is then never nil again. Ex: 2 phase initialization

The most commom scenario for reason 2 above is two-phase initialization. By the time the variables will be used, they will have a value.

### Two-phase initialization

Class initialization in Swift is a two-phase process. 
In the first phase, each stored property is assigned an initial value by the class that introduced it. 
Once the initial state for every stored property has been determined, the second phase begins, and each class is given the opportunity to customize its stored properties further before the new instance is considered ready for use
Two-phase initialization prevents property values from being accessed before they’re initialized, and prevents property values from being set to a different value by another initializer unexpectedly

4 safety-checks that compiler performs to make sure that two-phase initialization is completed without error

### Safety check 1

A designated initializer must ensure that all of the properties introduced by its class are initialized before it delegates up to a superclass initializer. 

### Safety check 2

A designated initializer must delegate up to a superclass initializer before assigning a value to an inherited property. If it doesn’t, the new value the designated initializer assigns will be overwritten by the superclass as part of its own initialization.

### Safety check 3

A convenience initializer must delegate to another initializer before assigning a value to any property (including properties defined by the same class). If it doesn’t, the new value the convenience initializer assigns will be overwritten by its own class’s designated initializer

### Safety check 4

An initializer can’t call any instance methods, read the values of any instance properties, or refer to self as a value until after the first phase of initialization is complete.

## Phase 1

* A designated or convenience initializer is called on a class.

* Memory for a new instance of that class is allocated. The memory isn’t yet initialized.

* A designated initializer for that class confirms that all stored properties introduced by that class have a value. The memory for these stored properties is now initialized.

* The designated initializer hands off to a superclass initializer to perform the same task for its own stored properties.

* This continues up the class inheritance chain until the top of the chain is reached.

* Once the top of the chain is reached, and the final class in the chain has ensured that all of its stored properties have a value, the instance’s memory is considered to be fully initialized, and phase 1 is complete.

## Phase 2

* Working back down from the top of the chain, each designated initializer in the chain has the option to customize the instance further. Initializers are now able to access self and can modify its properties, call its instance methods, and so on.

* Finally, any convenience initializers in the chain have the option to customize the instance and to work with self.

## Implicit Optional Behavior

Mesmo com ! uma variavel opcional continua sendo opcional.
Ou seja, é possivel utilizar ? ou ?? ou if let e etc
