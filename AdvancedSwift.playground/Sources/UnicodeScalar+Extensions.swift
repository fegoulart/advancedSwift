extension Unicode.Scalar: Strideable { // Adding Strideable conformance to Unicode.Scalar allows us to use a range of Unicode scalars as a very convenient way of generating an array of characters
    public typealias Stride = Int

    public func distance(to other: Unicode.Scalar) -> Int {
        return Int(other.value) - Int(self.value)
    }

    public func advanced(by n: Int) -> Unicode.Scalar {
        return Unicode.Scalar(UInt32(Int(value) + n))!
    }
}

