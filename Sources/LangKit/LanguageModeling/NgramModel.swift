//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import Foundation


public struct NgramModel {

    public enum SmoothingMode : NilLiteralConvertible {
        case none
        case laplace(Float)
        case goodTuring
        case linearInterpolation
        case absoluteDiscounting
        
        public init(nilLiteral: ()) {
            self = .none
        }
    }

    // Token type
    public typealias Token = String

    // Item type
    public typealias Item = [Token]

    // Gram number
    private let n: Int

    // Unknown replacement threshold
    private let threshold: Int

    // Smoothing mode
    private let smoothing: SmoothingMode

    // Ngram count trie
    private var counter: NgramCounter

    // Unigram count
    private var tokens: Set<Token> = []

    // Count frequency table for Good Turing smoothing
    private var countFrequency: [Int: Int]!

    /**
     Initializer

     - parameter n: Gram number
     */
    public init<C: Sequence where C.Iterator.Element == [Token]>
               (n: Int,
                trainingCorpus corpus: C?,
                smoothingMode smoothing: SmoothingMode = nil,
                unknownThreshold threshold: Int = 10,
                counter: NgramCounter = TrieNgramCounter()) {
        self.n = n
        self.smoothing = smoothing
        self.threshold = threshold
        self.counter = counter
        if case .goodTuring = smoothing {
            self.countFrequency = [:]
        }
        corpus >>- { self.train(corpus: $0) }
    }

}

// MARK: - Mutation
extension NgramModel {

    public mutating func insert(ngram: [Token]) {
        counter.insert(ngram)
        ngram.forEach { self.tokens.insert($0) }
    }

}

// MARK: - Smoothing utilities
extension NgramModel {

    /**
     Smooth Ngram based on the smoothing method

     - parameter ngram: Ngram item

     - returns: Smoothed ngram
     */
    private func smoothNgram(ngram: [Token]) -> [Token] {
        // 'Unk'ify (preprocess)
        let unkedNgram = ngram.map { tokens.contains($0) ? $0 : unknown }

        // Good Turing smoothing--preprocess only
        if case .goodTuring = smoothing {
            return unkedNgram
        }

        // Pregram does not exist
        if counter[unkedNgram.dropLast().map{$0}] == 0 {
            // Smooth pregram
            let presmoothedNgram = Array(repeating: unknown, count: n) + [unkedNgram.last!]
            return counter[presmoothedNgram] == 0
                ? presmoothedNgram.dropLast() + [unknown]
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
    public mutating func train<C: Sequence where C.Iterator.Element == [Token]>(corpus corpus: C) {
        let corpus = corpus.replaceRareTokens(minimumCount: threshold)
        for (i, sentence) in corpus.enumerated() {
            // Wrap <s> and </s> symbols
            let sentence = sentence.wrapSentenceBoundary()
            // Train the countTrie
            for ngram in sentence.ngrams(n) {
                // Insert ngram to trie; add ngram to token set
                self.insert(ngram)

                // Count frequency adjustment for Good Turing smoothing
                if case .goodTuring = smoothing {
                    let count = counter[ngram]
                    var prevCountFreq = countFrequency[count-1] ?? 0
                    if prevCountFreq != 0 {
                        prevCountFreq -= 1
                    }
                    countFrequency! <++ count
                }
            }
            // Print progress
            if i % 100 == 0 {
                debugPrint(terminator: ".")
            }
        }
        // If no (UNK, ..., UNK) present, insert one
        let unk = Array(repeating: unknown, count: n)
        if counter[unk] == 0 {
            self.insert(unk)
        }
        debugPrint()
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
        let count = counter[item]
        let total = counter.count
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
        let pregram = !!ngram.dropLast()

        // Count and precount smoothing
        let rawCount = counter[ngram]
        let count = rawCount == 0 ? 1 : rawCount
        let rawPrecount = counter[pregram]
        let precount = rawPrecount == 0 ? 1 : rawPrecount

        // Calculate probabiliy according to smoothing method
        var probability: Float
        switch smoothing {

        case .none:
            probability = Float(count) / Float(precount)

        case .laplace(let k):
            probability = (Float(count) + k) / (Float(precount) + Float(counter.count) * k)

        case .goodTuring:
            let numCount = countFrequency[count]!
            let numCountPlusOne = countFrequency[count + 1] ?? 1
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
        let probabilities = sentence.wrapSentenceBoundary().ngrams(n)
            .map { self.markovProbability($0, logspace: true) }
        return probabilities.reduce(0, combine: +)
    }

}
