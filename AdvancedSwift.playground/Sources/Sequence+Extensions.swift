import Foundation

extension Sequence where Element: Hashable {
    public var frequencies: [Element: Int] {
        let frequencyPairs = self.map { ($0, 1) }
        return Dictionary(frequencyPairs, uniquingKeysWith: +)
    }
}
