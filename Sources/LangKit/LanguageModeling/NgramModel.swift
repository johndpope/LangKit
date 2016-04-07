//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import Foundation

public enum SmoothingMode : NilLiteralConvertible {
    case None
    case Laplace
    case GoodTuring
    case LinearInterpolation
    case AbsoluteDiscounting
    
    public init(nilLiteral: ()) {
        self = .None
    }
}

public struct NgramModel {
    
    // Token type
    public typealias Token = String
    
    // Item type
    public typealias Item = [Token]
    
    // Gram number
    public var n: Int
    
    // Smoothing mode
    public var smoothing: SmoothingMode
    
    // Ngram count structure
    private var countTrie = Trie<Token>()
    
    // Unigram count
    private var tokens: Set<Token> = []
    
    // Count frequency table for Good Turing smoothing
    private var countFrequency: [Int: Int]?

    /**
     Initializer
     
     - parameter n: Gram number
     */
    public init(n: Int, smoothingMode smoothing: SmoothingMode = nil) {
        self.n = n
        self.smoothing = smoothing
        if smoothing == .GoodTuring {
            self.countFrequency = [:]
        }
    }
    
}

// MARK: - Mutation
extension NgramModel {
    
    public mutating func insert(ngram: [Token]) {
        self.countTrie = countTrie.insert(ngram, incrementingNodes: true)
        ngram.forEach { self.tokens.insert($0) }
    }
    
}

// MARK: - Count properties
extension NgramModel {
    
    public func count(ngram: [Token]) -> Int {
        return countTrie.count(ngram)
    }
    
    public var count: Int {
        return countTrie.count([])
    }
    
}

// MARK: - Smoothing utilities
extension NgramModel {
    
    private func smoothNgram(ngram: [Token]) -> [Token] {
        // 'Unk'ify (preprocess)
        let unkedNgram = ngram.map { tokens.contains($0) ? $0 : Preprocessor.unknown }
        
        // Good Turing smoothing--preprocess only
        if smoothing == .GoodTuring {
            return unkedNgram
        }
        
        // Pregram does not exist
        if self.count(unkedNgram.dropLast().map{$0}) == 0 {
            // Smooth pregram
            let presmoothedNgram = Array(repeating: Preprocessor.unknown, count: n) + [unkedNgram.last!]
            return self.count(presmoothedNgram) == 0
                ? presmoothedNgram.dropLast() + [Preprocessor.unknown]
                : presmoothedNgram
        }
        
        // Ngram exists
        return unkedNgram
    }
    
}

// MARK: - LanguageModel conformity
extension NgramModel : LanguageModel {

    /**
     Train the model with tokenized corpus
     
     - parameter corpus: Tokenized corpus
     */
    public mutating func train(corpus: [[Token]]) {
        let corpus = Preprocessor.replaceRareTokens(in: corpus, unknownThreshold: 10)
        corpus.forEach { sentence in
            // Wrap <s> and </s> symbols
            let sentence = Preprocessor.wrapSentenceBoundary(sentence)
            // Train the countTrie
            sentence.ngrams(n).forEach { ngram in
                self.insert(ngram)
                if smoothing == .GoodTuring {
                    let count = self.count(ngram)
                    var prevCountFreq = countFrequency![count-1] ?? 0
                    if prevCountFreq != 0 {
                        prevCountFreq -= 1
                    }
                    countFrequency![count] = (countFrequency![count] ?? 0) + 1
                }
            }
        }
        // If no (UNK, ..., UNK) present, insert one
        let unkNgram = Array(repeating: Preprocessor.unknown, count: n)
        if self.count(unkNgram) == 0 {
            self.insert(unkNgram)
        }
    }

    /**
     Probability of item
     
     - parameter item:     Ngram
     - parameter logspace: Enable logspace
     
     - returns: Probability
     */
    public func probability(item: Item, logspace: Bool = false) -> Float {
        guard item.count == n else {
            return 0
        }
        let count = countTrie.count(item)
        let total = countTrie.count([])
        let probability = Float(count) / Float(total)
        return logspace ? log(probability) : probability
    }
    
    /**
     Markov conditional probability of item
     
     - parameter item:     Ngram
     - parameter logspace: Enable logspace
     
     - returns: Probability
     */
    public func markovProbability(item: Item, logspace: Bool = false) -> Float {
        // Ngram and pregram ({N-1}gram)
        let ngram = smoothNgram(item)
        let pregram = ngram.dropLast().map{$0}
        
        // Count and precount smoothing
        let rawCount = countTrie.count(ngram)
        let count = rawCount == 0 ? 1 : rawCount
        let rawPrecount = countTrie.count(pregram)
        let precount = rawPrecount == 0 ? 1 : rawPrecount
        
        // Calculate probabiliy according to smoothing method
        var probability: Float
        switch smoothing {
            
        case .None:
            probability = Float(count) / Float(precount)
            
        case .Laplace:
            probability = Float(count + 1) / Float(precount + self.count)
            
        case .GoodTuring:
            let numCount = countFrequency![count]!
            let numCountPlusOne = countFrequency![count + 1] ?? 1
            probability = Float(count + 1) * (Float(numCountPlusOne) / Float(numCount))
            
        default:
            probability = 0.0 // TODO: Implement other smoothing methods
        }
        
        return logspace ? log(probability) : probability
    }
    
    /**
     Log probability of tokenized sentence
     
     - parameter sentence: Tokenized sentence
     
     - returns: Log probability
     */
    public func sentenceLogProbability(sentence: [Token]) -> Float {
        let probabilities = sentence.ngrams(n).map { self.markovProbability($0, logspace: true) }
        return probabilities.reduce(0, combine: +)
    }

}
