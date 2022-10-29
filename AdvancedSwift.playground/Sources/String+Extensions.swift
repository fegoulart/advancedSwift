import Foundation

extension String {
    public func wrapped(after maxLength: Int = 70) -> String {
        var lineLength = 0
        let lines = self.split(omittingEmptySubsequences: false) { character in
            if character.isWhitespace && lineLength >= maxLength {
                lineLength = 0
                return true // isSeparator
            } else {
                lineLength += 1
                return false // 
            }
        }
        return lines.joined(separator: "\n")
    }
}
