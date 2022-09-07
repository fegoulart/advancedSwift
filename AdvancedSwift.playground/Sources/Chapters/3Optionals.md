# 2 OPTIONALS

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

// Parei aqui antes de Optional Chaining
