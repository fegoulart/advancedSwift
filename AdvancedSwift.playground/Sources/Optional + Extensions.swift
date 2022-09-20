import Foundation

extension Optional {

    // se for nil, retorna nil, se nao aplica a transformacao
    public func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let value = self else { return nil }
        return transform(value)
    }

    public func flatMap<U>(transform: (Wrapped) -> U?) -> U? {
        if let value = self, let transformed = transform(value) {
            return transformed
        }
        return nil
    }

}
