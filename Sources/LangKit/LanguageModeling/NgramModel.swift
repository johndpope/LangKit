//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import Foundation


public struct NgramModel {

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
                replacingTokensFewerThan threshold: Int = 1,
                @autoclosure counter counterInit: () -> NgramCounter = TrieNgramCounter()) {
        self.n = n
        self.smoothing = smoothing
        self.threshold = threshold
        self.counter = counterInit()
        if case .goodTuring = smoothing {
            self.countFrequency = [:]
        }
        corpus >>- { self.train(corpus: $0) }
    }

}

// MARK: - Mutation
extension NgramModel {

    public mutating func insert(_ ngram: [Token]) {
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
    private func smoothNgram(_ ngram: [Token]) -> [Token] {
        // 'Unk'ify (preprocess)
        let unkedNgram = ngram.map { tokens.contains($0) ? $0 : unknown }

        let pregram = !!ngram.dropLast()
        let last = ngram.last!

        if !counter.contains(ngram: pregram) {
            return Array(repeating: unknown, count: pregram.count) + [last]
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
    public mutating func train<C: Sequence where
                                   C.Iterator.Element == [Token]>
                               (corpus: C) {
        let corpus = corpus.replaceRareTokens(minimumCount: threshold)
        for sentence in corpus {
            // Wrap <s> and </s> symbols
            let sentence = sentence.wrapSentenceBoundary()
            // Train the countTrie
            for ngram in sentence.ngrams(n) {
                // Insert ngram to trie; add ngram to token set
                self.insert(ngram)

                // Count frequency adjustment for Good Turing smoothing
                if case .goodTuring = smoothing {
                    let count = counter[ngram]
                    let prevCountFreq = countFrequency[count-1] ?? 0
                    if prevCountFreq > 0 {
                        countFrequency[count-1] = prevCountFreq - 1
                    }
                    countFrequency[count] ?+= 1
                }
            }
        }
        // If no (UNK, ..., UNK) present, insert one
        let unk = Array(repeating: unknown, count: n)
        if counter[unk] == 0 {
            self.insert(unk)
        }
    }

    /**
     Probability of item

     - parameter item:     Ngram
     - parameter logspace: Enable logspace

     - returns: Probability
     */
    public func probability(_ item: Item) -> Float {
        guard item.count == n else {
            return 0
        }
        let count = counter[item]
        let total = counter.count
        return Float(count) / Float(total)
    }

    /**
     Markov conditional probability of item

     - parameter item:     Ngram
     - parameter logspace: Enable logspace

     - returns: Probability
     */
    public func markovProbability(_ item: Item) -> Float {
        // Ngram and pregram ({N-1}gram)
        let ngram = smoothNgram(item)
        let pregram = !!ngram.dropLast()

        // Count and precount smoothing
        let count = counter[ngram]
        let precount = counter[pregram]

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
            let smoothedCount = Float(count + 1) * Float(numCountPlusOne) / Float(numCount)
            probability = smoothedCount / Float(precount)

        case .absoluteDiscounting:
            // TODO
            probability = 0.0

        case .linearInterpolation:
            // TODO
            probability = 0.0
        }

        return probability
    }

    /**
     Log probability of tokenized sentence

     - parameter sentence: Tokenized sentence

     - returns: Log probability
     */
    public func sentenceLogProbability(_ sentence: [Token]) -> Float {
        return sentence.wrapSentenceBoundary().ngrams(n)
            .reduce(0, combine: (+) • logf • markovProbability)
    }

}
