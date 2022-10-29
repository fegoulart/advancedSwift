import Foundation

extension Collection where Element: Equatable {
    public func split<S: Sequence>(separators: S) -> [SubSequence] where Element == S.Element {
        return split { separators.contains($0) }
    }
}
