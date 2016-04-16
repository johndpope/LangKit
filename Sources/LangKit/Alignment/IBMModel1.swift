//
//  IBMModel1.swift
//  LangKit
//
//  Created by Richard Wei on 3/21/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

internal func ==(lhs: IBMModel1.WordPair, rhs: IBMModel1.WordPair) -> Bool {
    return lhs.first == rhs.first && lhs.second == rhs.second
}

/// Classic algorithm of IBM Model 1
public class IBMModel1: Aligner {

    /**
     *  Word pair hash key
     */
    internal struct WordPair : Hashable {
        var first, second: String

        var hashValue: Int {
            return "\(first), \(second)".hashValue
        }

        init(_ first: String, _ second: String) {
            self.first = first
            self.second = second
        }
    }

    public typealias SentenceTuple = ([String], [String])

    public var bitext: [([String], [String])]

    internal var trans: [WordPair: Float]

    internal var threshold: Float

    internal let initialTrans: Float = 0.1

    internal func translationProbability(_ pair: WordPair) -> Float {
        return trans[pair] ?? initialTrans
    }

    public init(bitext: [SentenceTuple], probabilityThreshold threshold: Float) {
        self.bitext = bitext
        self.trans = [:]
        self.threshold = threshold
    }

    public convenience required init(bitext: [SentenceTuple]) {
        self.init(bitext: bitext, probabilityThreshold: 0.9)
    }

    public func train(iterations: Int = 100) {
        var count = [WordPair: Float]()
        var total = [String: Float]()
        var sTotal = [String: Float]()
        for iter in 1...iterations {
            bitext.forEach { f, e in
                // Compute normalization
                e.forEach { ej in
                    sTotal[ej] = 0.0
                    f.forEach { fi in
                        let pair = WordPair(ej, fi)
                        sTotal[ej] = translationProbability(pair)
                    }
                }
                // Collect counts
                e.forEach { ej in
                    f.forEach { fi in
                        let pair = WordPair(ej, fi)
                        let transProb = translationProbability(pair)
                        count[pair] = (count[pair] ?? 0.0) + transProb / sTotal[ej]!
                        total[fi] = (total[fi] ?? 0.0) + transProb / sTotal[ej]!
                    }
                }
            }
            // Update translation probability
            count.keys.forEach { pair in
                self.trans[pair] = count[pair]! / total[pair.second]!
            }

            // Debug progress output
            let progress = Float(iter) / Float(iterations) * 100
            if progress % 10 == 0 {
                debugPrint(progress)
            }

            // Re-initialization
            count.removeAll(keepingCapacity: true)
            total.removeAll(keepingCapacity: true)
            sTotal.removeAll(keepingCapacity: true)
        }
    }

    /**
     Compute alignment for a sentence pair

     - parameter eSentence: source tokenized sentence
     - parameter fSentence: destination tokenized sentence

     - returns: alignment dictionary
     */
    public func align(fSentence: [String], eSentence: [String]) -> [Int: Int]? {
        if trans.isEmpty { return nil }
        var alignment = [Int: Int]()
        for (j, ej) in eSentence.enumerated() {
            for (i, fi) in fSentence.enumerated() {
                let probability = translationProbability(WordPair(ej, fi))
                if probability >= threshold {
                    alignment[i] = j
                }
            }
        }
        return alignment
    }



}
