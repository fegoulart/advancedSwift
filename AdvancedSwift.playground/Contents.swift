import Foundation

// MARK: - Collections

// Splits equals elements
let array: [Int] = [1, 2, 2, 2, 3, 4, 4]
let splitResult = array.split(where: !=) // array.split { $0 != $1 }
// print(splitResult)


// Accumulate
// print([1, 2, 3, 4].accumulate(0, +)) // [1, 3, 6, 10]


// Map + filter

(1..<10).map { $0 * $0 }.filter { $0 % 2 == 0 } // [4, 16, 36, 64 ]

// Filter mais eficiente

(1..<10).map { $0 * $0 }.filter3 { $0 % 2 == 0 } // [4, 16, 36, 64]

// flatMap

let suits = ["♠️", "♥️", "♣️", "♦️"]
let ranks = ["A", "K", "Q", "J"]
let suitsResult: [(String, String)] = suits.flatMap { suit in
    ranks.map { rank in
        (suit, rank)
    }
}
// print(suitsResult)

// forEach

(1..<10).forEach { number in
    // print(number)
    if number > 2 { return } // return here won't exit the forEach
}

// Array Slices

let slice = array[1...]
let sliceArray: [Int] = Array(slice)
//print(slice)
type(of: slice) // ArraySlice<Int>
// print(slice.startIndex)
// print(slice.endIndex)

// Dictionaries

var clothes: [String: [String]] = [:]
var previousValue = clothes.updateValue(["green", "gray", "jeans"], forKey: "pants")
// print(previousValue as Any)
previousValue = clothes.removeValue(forKey: "pants")
// print(previousValue as Any)

let frequencies = "hello".frequencies // ["h": 1, "o": 1, "l": 2, "e": 1]
print(frequencies.filter { $0.value > 1 }) // ["l": 2]

enum Setting {
    case text(String)
    case int(Int)
    case bool(Bool)
}

let settings: [String: Setting] = [
    "Name": .text("Jane's Iphone"),
    "Airplane Mode": Setting.bool(false)
]

// mapValues tranforma os valores sem mexer nas chaves
let settingsAsStrings = settings.mapValues { setting -> String in
    switch setting{
    case .text(let text): return text
    case .int(let number): return String(number)
    case .bool(let value): return String(value)
    }
}

print(settingsAsStrings)

// Sets

let iPods: Set = ["iPod touch", "iPod nano", "iPod mini", "iPod shuffle", "iPod classic"]
let discontinuedIPods: Set = ["iPod mini", "iPod classic", "iPod nano", "iPod shuffle"]
let currentIPods = iPods.subtracting(discontinuedIPods)

let touchScreen: Set = ["iPhone", "iPad", "iPod touch", "iPod nano"]
let iPodsWithTouch = iPods.intersection(touchScreen)

var discontinued: Set = ["iBook", "PowerBook", "Power Mac"]
discontinued.formUnion(discontinuedIPods)

// IndexSet

var indices = IndexSet()
indices.insert(integersIn: 1..<5)
indices.insert(integersIn: 11..<15)
let evenIndices = indices.filter { $0 % 2 == 0 }

print([1, 2, 3, 12, 1, 3, 4, 5, 6, 4, 6].unique())

// MARK: - Optionals

var opt1Array = ["one", "two", "three"]
switch opt1Array.firstIndex(of: "four") {
case .some(let idx):
    opt1Array.remove(at: idx)
case .none:
    break
}

var opt2Array = ["one", "two", "three"]
if let idx = opt2Array.firstIndex(of: "four") {
    opt2Array.remove(at: idx)
}

let opt3Array = [1, 2, 3]
var iterator = opt3Array.makeIterator()
while let i = iterator.next() {
    print(i, terminator: " ")
}

for i in 0..<10 where i%2 == 0 {
    print(i, terminator:" ")
} // 0 2 4 6 8

var iterator2 = (0..<10).makeIterator()
while let i = iterator2.next() {
    guard i % 2 == 0 else { continue }
    print(i)
}

let stringNumbers = ["1", "2", "three"]
let maybeInts: [Int?] = stringNumbers.map { Int($0) } // [Optional(1), Optional(2), nil]

var iterator3 = maybeInts.makeIterator()
while let maybeInt = iterator3.next() {
    print(maybeInt, terminator: " ")
}
// Optional(1) Optional(2) nil ---> Aqui vai acabar imprimindo nil pq nesse caso, iterator.next() era .some(nil)

for case let i? in maybeInts {
    // i will be an Int not an Int?
    print(i, terminator: " ")
}

for case nil in maybeInts {
    // Will run once for each nil
}

for case let .some(i) in maybeInts { // for case i? in maybeInts
    print(i)
}

let j = 5
if case 0..<10 = j { // if case é equivalente a switch j { case let 5: ...
    print("\(j) within range")
}
// 5 within range

var a: Int? = 5
a? = 10
// a == Optional(10)

var b: Int? = nil
b? = 10
// b == nil

let i2: Int? = nil
let j2: Int? = nil
let k2: Int? = 42

i2 ?? j2 ?? k2 ?? 0 //42

var bodyTemperature: Double? = 37

print("Body temperature: \(bodyTemperature ??? "n/a")")

[1, 2, 3].reduce_alt { firstResult, nextPartialResult in
    return firstResult + nextPartialResult
}

// flatMap works as if let

// Implementing if let with flatMap:

//let urlString = "https://www.objc.io/logo.png"
//let view = URL(string: urlString)
//    .flatMap { try? Data(contentsOf: $0) }
//    .flatMap { UIImage(data: $0) }
//    .map { UIImageView(image: $0)}
//
//if let view = view {
//    PlaygroundPage.current.liveView = view
//}

// Implementing flatMap with if let:

//extension Optional {
//    func flatMap<U>(transform: (Wrapped) -> U?) -> U? {
//        if let value = self, let transformed = transform(value) {
//            return transformed
//        }
//        return nil
//    }
//}

// let s3 = "foo"
// let i3 = Int(s3) !! "Expecting integer, got \"\(s3)\""

// var output: String? = nil
// output?.write("something") !? "Wasn't expected chained nil here"

// MARK: - Functions

func counterFunc() -> (Int) -> String {
    var counter = 0
    func innerFunc(i: Int) -> String {
        counter += i
        return "Running total: \(counter)"
    }
    return innerFunc
}

let f = counterFunc()
f(10)
f(1)
f(5)

// MARK: - Functions

// Sorted is available when element conforms to Comparable

let fArray = [3, 1, 2]
fArray.sorted()
fArray.sorted(by: >)

// sort can be used when elements don't conform to Comparable but do have < operator

var numberStrings = [(2, "two"), (1, "one"), (3, "three")]
numberStrings.sort(by: <)

// more complex sort

let animals = ["elephant", "zebra", "dog"]
animals.sorted { lhs, rhs in // zebra, dog, elephant
    let i = lhs.reversed()
    let r = rhs.reversed()
    return i.lexicographicallyPrecedes(r)
}

// Function as Data

//@objcMembers
//final class Person: NSObject {
// final class Person {
struct Person {
    let first: String
    let last: String
    let yearOfBirth: Int
    init(first: String, last: String, yearOfBirth: Int) {
        self.first = first
        self.last = last
        self.yearOfBirth = yearOfBirth
    }
}

let people = [
    Person(first: "Emily", last: "Young", yearOfBirth: 2022),
    Person(first: "David", last: "Gray", yearOfBirth: 1991),
    Person(first: "Robert", last: "Barnes", yearOfBirth: 1985),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 2000),
    Person(first: "Joanne", last: "Miller", yearOfBirth: 1994),
    Person(first: "Ava", last: "Barnes", yearOfBirth: 1998)
]

typealias SortDescriptor<Root> = (Root, Root) -> Bool

func sortDescriptor<Root, Value>(
    key: @escaping(Root) -> Value,
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

let sortByYearAlt2: SortDescriptor<Person> = sortDescriptor(key: { $0.yearOfBirth })

people.sorted(by: sortByYearAlt2)

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

let sortByFirstName: SortDescriptor<Person> = sortDescriptor(key: { $0.first }, by: String.localizedStandardCompare)
people.sorted(by: sortByFirstName)

func combine<Root>(sortDescriptors: [SortDescriptor<Root>]) -> SortDescriptor<Root> {
    return { lhs, rhs in
        for areInIncreasingOrder in sortDescriptors {
            if areInIncreasingOrder(lhs, rhs) { return true }
            if areInIncreasingOrder(rhs, lhs) { return false }
        }
        return false
    }
}

let sortByLastName: SortDescriptor<Person> = sortDescriptor(key: { $0.last }, by: String.localizedStandardCompare)

let combined: SortDescriptor<Person> = combine(sortDescriptors: [sortByLastName, sortByFirstName, sortByYearAlt2])
people.sorted(by: combined)

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

// Optionals

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
// let result = files.sorted(by : sortDescriptor(key: { $0.fileExtension }, by: compare))
// result // "one", "file.c", "file.h", "test.h"

// MARK: - Function as Delegate

print("-------------------- FUNCTION AS DELEGATE -----------------")
class AlertView {
    var buttons: [String]
    var buttonTapped: ((_ buttonIndex: Int) -> Void)? // replacing delegate with a callback

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

class ViewController {
    let alert: AlertView

    init(alert: AlertView = AlertView(buttons: ["OK", "Cancel"])) {
        // alert = AlertView(buttons: ["OK", "Cancel"])
        self.alert = alert
        alert.buttonTapped = self.buttonTapped(atIndex:) // PROBLEM: We are creating here a reference cycle
    }

    func buttonTapped(atIndex index: Int) {
        print("Button tapped: \(index)")
    }
}

let alert = AlertView()
var logger = TapLogger()
let vc = ViewController(alert: alert)
alert.fire()


// MARK: Strings

let poem = """
    Over the wintry
    forest, winds howl in rage
    with no leaves to blow.
    """

let lines = poem.split(separator: "\n") // ["Over the wintry", "forest, winds howl in rage", "with no leaves to blow."]
print(type(of: lines)) // Array<Substring>

print(lines[1])

let sentence = "The quick brown fox jumped over the lazy dog."

// wrapped is custom extension
sentence.wrapped(after: 15)  // "The quick brown\nfox jumped over\nthe lazy dog."

// split(separators:) is custom extension

"Hello, world!".split(separators: ",! ") // ["Hello", "world"]

func lastWord(in input: String) -> String? {
    let words = input.split(separators: [",", " "]) // Array<Substring>
    guard let lastWord = words.last else { return nil }
    return String(lastWord) // Convert to String
}

lastWord(in: "one, two, three, four, five") // Optional("five")

// UTF-8

let tweet = "Having ☕️ in a cafe\u{301} in 🇮🇹 and enjoying the ☀️."
let characterCount = tweet.precomposedStringWithCanonicalMapping.unicodeScalars.count
print(characterCount) // 46
print(tweet.count) // 43

let utfBytes = Data(tweet.utf8)
print(utfBytes.count) // 62

let nullTerminatedUTF8 = tweet.utf8CString
print(nullTerminatedUTF8.count) // 63

let pokemon = "Poke\u{301}mon" // Pokémon
if let index = pokemon.firstIndex(of: "é") {
    let scalar = pokemon.unicodeScalars[index] // 101
    String(scalar) // e
}

let family = "👨‍👩‍👦‍👦"
// UTF-16 index offset
let someUTF16Index = String.Index(utf16Offset: 3, in: family)
let familyResult = family[someUTF16Index]
print(familyResult)

let lowercaseLetters = ("a" as Character)..."z" // ClosedRange<Character>
lowercaseLetters.contains("A") // false
lowercaseLetters.contains("é") // false

let lowercase = ("a" as Unicode.Scalar)..."z"
Array(lowercase.map(Character.init))

let fernando = "Fernando"
let fernandoArrayChars = Array(fernando.map(Character.init))
type(of: fernandoArrayChars[2]) // Character


// MARK: - Custom copy-on-write

FernandoCopyOnWrite.main()

// MARK: - MemoryLayout

class CopaDoMundo {
    var computador: String?

    init() {}
}

print(MemoryLayout<CopaDoMundo>.size) // 8
