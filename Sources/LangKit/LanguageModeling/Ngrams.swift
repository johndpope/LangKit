/**
 * Ngram.swift
 *
 */

public enum NgramForm {
    case Letter
    case Word
}

public extension Array where Element : Equatable {

    public func ngrams(n: Int) -> Ngrams<Element> {
        return Ngrams<Element>(n, source: self)
    }

}

public extension String {

    public func ngrams(n: Int, form: NgramForm) -> Ngrams<String> {
        switch form {
        case .Letter:
            return characters.map{String($0)}.ngrams(n)
        case .Word:
            return self.tokenized().ngrams(n)
        }
    }

}

public struct Ngrams<T> : IteratorProtocol, Sequence {

    public typealias Element = [T]

    private(set) var n: Int
    private var source: [T]

    public init(_ n: Int, source: [T]) {
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
        let ngram = source[0..<n].map{$0}
        self.source.removeFirst()
        return ngram
    }

}

public extension Ngrams {
    public func toArray() -> [Element] {
        return Array(self)
    }
}
