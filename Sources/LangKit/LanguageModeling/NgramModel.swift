//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public enum SmoothingMode {
    case Laplace
    case GoodTuring
    case LinearInterpolation
    case AbsoluteDiscounting
}

public struct NgramModel<T: Hashable> {
    
    // Token type
    public typealias Token = T
    
    // Item type
    public typealias Item = [Token]
    
    // Token replacements for preprocessing
    private let unknown = "UNK"
    private let sentenceStart = "<s>"
    private let sentenceEnd = "</s>"
    
    // Gram number
    public var n: Int
    
    // Smoothing mode
    public var smoothing: SmoothingMode
    
    // Trie structure
    private var trie = Trie<Token>()

    /**
     Initializer
     
     - parameter n: Gram number
     */
    public init(n: Int, smoothingMode smoothing: SmoothingMode) {
        self.n = n
        self.smoothing = smoothing
    }
    
}

// MARK: - Preprocessing
extension NgramModel {
    
    /**
     Preprocess corpus
     
     - parameter corpus: Tokenized corpus
     
     - returns: Preprocessed corpus
     */
    private func preprocess(corpus: [[Token]]) -> [[Token]] {
        return corpus.map { sentence in
            sentence.map { token in
                // TODO
                token
            }
        }
    }
    
}

// MARK: - Mutation
extension NgramModel {
    
    private mutating func insert(ngram: [Token]) {
        self.trie = trie.insert(ngram)
    }
    
}

// MARK: - LanguageModel conformity
extension NgramModel : LanguageModel {

    /**
     Train the model with tokenized corpus
     
     - parameter corpus: Tokenized corpus
     */
    public mutating func train(corpus: [[Token]]) {
        corpus.forEach { sentence in
            sentence.ngrams(n).forEach { ngram in
                // TODO
                insert(ngram)
            }
        }
    }

    /**
     Probability of item
     
     - parameter item: Ngram
     - parameter logspace: Enable logspace
     
     - returns: Probability
     */
    public func probability(item: Item, logspace: Bool = true) -> Float {
        let count = trie.count(item)
        // TODO
        return 0.0
    }
    
    /**
     Markov conditional probability of item
     
     - parameter item: Ngram
     - parameter logspace: Enable logspace
     
     - returns: Probability
     */
    public func markovProbability(item: Item, logspace: Bool = true) -> Float {
        // P(w_n | w_1...w_{n-1})
        let condCount = trie.count(item.dropLast().map{$0})
        // P(w_1...w_n)
        let count = trie.count(item)
        // TODO
        return 0.0
    }

}
