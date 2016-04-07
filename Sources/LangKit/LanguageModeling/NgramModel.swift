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
    private var n: Int

    // Unknown replacement threshold
    private var threshold: Int

    // Smoothing mode
    private var smoothing: SmoothingMode

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
    public init(n: Int, trainingCorpus corpus: [[Token]]?, smoothingMode smoothing: SmoothingMode = nil, unknownThreshold threshold: Int = 10) {
        self.n = n
        self.smoothing = smoothing
        self.threshold = threshold
        if smoothing == .GoodTuring {
            self.countFrequency = [:]
        }
        if let corpus = corpus {
            self.train(corpus)
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
        let corpus = Preprocessor.replaceRareTokens(in: corpus, unknownThreshold: threshold)
        for (i, sentence) in corpus.enumerated() {
            // Wrap <s> and </s> symbols
            let sentence = Preprocessor.wrapSentenceBoundary(sentence)
            // Train the countTrie
            for ngram in sentence.ngrams(n) {
                // Insert ngram to trie; add ngram to token set
                self.insert(ngram)

                // Count frequency adjustment for Good Turing smoothing
                if smoothing == .GoodTuring {
                    let count = self.count(ngram)
                    var prevCountFreq = countFrequency![count-1] ?? 0
                    if prevCountFreq != 0 {
                        prevCountFreq -= 1
                    }
                    countFrequency![count] = (countFrequency![count] ?? 0) + 1
                }
            }
            // Print progress
            if i % 100 == 0 {
                debugPrint(terminator: ".")
            }
        }
        // If no (UNK, ..., UNK) present, insert one
        let unk = Array(repeating: Preprocessor.unknown, count: n)
        if self.count(unk) == 0 {
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
        let probabilities = Preprocessor.wrapSentenceBoundary(sentence).ngrams(n)
            .map { self.markovProbability($0, logspace: true) }
        return probabilities.reduce(0, combine: +)
    }

}
