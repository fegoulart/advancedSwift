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
