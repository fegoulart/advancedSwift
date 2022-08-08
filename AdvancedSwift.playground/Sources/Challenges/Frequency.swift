
// Write a function that accepts 2 parameters:
let param1 = [1, 2, 2, 2, 4, 7, 8, 9]
// param2: 2
// return: 3

func freq(param1: [Int], param2: Int) -> Int {
    guard !param1.isEmpty, param1.first! <= param2, param1.last! >= param2  else {
        return 0
    }
    var repetitions = 0 // O(n) // O(log(n))
    for number in param1 {
        if number == param2 {
            repetitions += 1
        }
    }
    return repetitions
}
// let param1 = [1, 2, 2, 2, 4, 7, 8, 9]
//let param1 = [2, 2, 2, 2]
let param2 = 2
// print(freq(param1: param1, param2: param2))
// Edges case
// empty
// last number < param2
// param2 < first number

enum WhereToGo {
    case left
    case right
    case found(Int)
}

func recursiveSearch(param1: ArraySlice<Int>, param2: Int) -> Int? {
    let pointer: Int = param1.startIndex + param1.count / 2
    let param1Size: Int = Array(param1).count // - Int(param1.firstIndex)
    print("param1 slice size: \(param1Size)")
    print(pointer)
    guard !param1.isEmpty, param1.first! <= param2, param1.last! >= param2  else {
        return nil
    }
    if param1[pointer] == param2 {
        return pointer
    }
    let whereTo = findIndex(param1, param2, pointer)
    print("pointer = \(pointer) - whereTo: \(whereTo)")
    switch (whereTo) {
    case .left:
        var firstSlice = param1[param1.startIndex...pointer-1]
        print("Param1 startIndex = \(param1.startIndex)")
        return recursiveSearch(param1: firstSlice, param2: param2)
    case .right:
        print("Param1 endIndex = \(param1.endIndex)")
        var secondSlice = param1[pointer+1...param1.endIndex-1]
        return recursiveSearch(param1: secondSlice, param2: param2)
    default:
        return nil
    }
    return nil
}

func findIndex(_ slice: ArraySlice<Int>, _ param2: Int, _ pointer: Int) -> WhereToGo? {
    guard !slice.isEmpty, slice.first! <= param2, slice.last! >= param2  else {
        return nil
    }

    if slice[pointer] == param2 {
        return .found(pointer)
    } else if slice[pointer] > param2 {
        return .left
    } else if slice[pointer] < param2 {
        return .right
    }
    return nil
}

func betterFreq(param1: [Int], param2: Int) -> Int {
    let slice = param1[0...param1.count-1]
    if let foundIndex = recursiveSearch(param1: slice, param2: param2) {
        // print("foundIndex = \(foundIndex)")
        return countFreq(param1: param1, param2: param2, pointer: foundIndex)
    }
    return 0
}

func countFreq(param1: [Int], param2: Int, pointer: Int) -> Int {
    guard param1[pointer] == param2 else { return 0 }
    var newPointer = pointer - 1
    var frequency = 1
    if newPointer > 0 {
        while param1[newPointer] == param2 {
            frequency += 1
            newPointer = newPointer - 1
            guard newPointer >= 0 else { break }
        }
    }

    newPointer = pointer + 1
    if newPointer < param1.count {
        while param1[newPointer] == param2 {
            frequency += 1
            newPointer = newPointer + 1
            guard newPointer < param1.count else { break }
        }
    }
    return frequency
}

// print(betterFreq(param1: [2, 2, 2, 2, 2, 2, 6, 9], param2: 8))
// print(betterFreq(param1: [2, 8, 9], param2: 8))
/// Recursion
// break if param2 out of range
//
// var fernando = [1, 2, 2, 2, 4, 7, 8, 9]
// print(fernando[1...7].first)

let mSlice: ArraySlice<Int> = [2, 2, 2, 2, 2, 2, 8, 9][5...7]

// print(mSlice[0])
// print(mSlice[5])
// print(mSlice[mSlice.startIndex])

let result = recursiveSearch(param1: [0, 2, 2, 2, 2, 2, 6, 9][0...7], param2: 1)
// print("Result = \(result)")


