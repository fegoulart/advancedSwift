import Foundation

extension Array {
    public func split(where condition:(Element, Element) -> Bool) -> [[Element]] {
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

    public func accumulate<Result>(_ initialResult: Result, _ nextPartialResult: (Result, Element) -> Result) -> [Result] {
        var running = initialResult
        return map { next in
            running = nextPartialResult(running, next)
            return running
        }
    }

    // Efficient filter using just reduce(into:) - O(n)
    public func filter3(_ isIncluded: (Element) -> Bool) -> [Element] {
        return reduce(into: []) { result, element in
            if isIncluded(element) {
                result.append(element)
            }
        }
    }
}
