/**
 * Ngram.swift
 *
 */

public enum NgramForm {
    case letter
    case word
}

public extension Array {

    public func ngrams(_ n: Int) -> Ngrams<Element> {
        return .init(self, n)
    }

}

public extension String {

    public func ngrams(_ n: Int, form: NgramForm) -> Ngrams<String> {
        switch form {
        case .letter:
            return characters.map{String($0)}.ngrams(n)
        case .word:
            return self.tokenize().ngrams(n)
        }
    }

}

public struct Ngrams<T> : IteratorProtocol, Sequence {

    public typealias Element = [T]

    private let n: Int
    private var source: [T]

    public init(_ source: [T], _ n: Int) {
        self.n = n
        self.source = source
    }

    public func generate() -> Ngrams {
        return self
    }

    public mutating func next() -> Element? {
        guard source.count >= n else {
            return nil
        }
        let ngram = !!source[0..<n]
        self.source.removeFirst()
        return ngram
    }

}

public extension Ngrams {
    public func toArray() -> [Element] {
        return Array(self)
    }
}
