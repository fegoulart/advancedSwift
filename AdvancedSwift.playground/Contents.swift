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

let s3 = "foo"
let i3 = Int(s3) !! "Expecting integer, got \"\(s3)\""

var output: String? = nil
output?.write("something") !? "Wasn't expected chained nil here"

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
