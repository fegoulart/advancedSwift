import Foundation

// MARK: - Arrays

// Splits equals elements
let array: [Int] = [1, 2, 2, 2, 3, 4, 4]
let splitResult = array.split(where: !=) // array.split { $0 != $1 }
print(splitResult)


// Accumulate
print([1, 2, 3, 4].accumulate(0, +)) // [1, 3, 6, 10]

extension Array {
    func split(where condition:(Element, Element) -> Bool) -> [[Element]] {
        var result:[[Element]] = self.isEmpty ? [] : [[self[0]]]
        for (previous, current) in zip(self, self.dropFirst()) {
            if condition(previous,current) {
                result.append([current])
            } else {
                result[result.endIndex - 1].append(current)
            }
        }
        return result
    }

    func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }
}
