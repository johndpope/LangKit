/**
 * Ngram.swift
 *
 */

public class NgramModel {
    
    public typealias ItemType = [String]

    public var n: Int

    public init(n: Int) {
        self.n = n
    }

}

extension NgramModel : LanguageModel {

    public func train() {
        // TODO
    }

    public func probability(item: ItemType) -> Float {
        return 0.0
    }

}
