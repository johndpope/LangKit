//
//  IBMModel1.swift
//  LangKit
//
//  Created by Richard Wei on 3/21/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

/// Classic algorithm of IBM Model 1
public class IBMModel1: Aligner {

    public typealias SentenceTuple = ([String], [String])

    typealias Key = ArrayKey<String>

    internal var trans: [Key: Float]

    internal var threshold: Float

    internal let initialTrans: Float = 0.1

    public init<S: Sequence where S.Iterator.Element == SentenceTuple>(bitext: S, probabilityThreshold threshold: Float) {
        self.trans = [:]
        self.threshold = threshold
        train(bitext: bitext)
    }

    public convenience required init(bitext: [SentenceTuple]) {
        self.init(bitext: bitext, probabilityThreshold: 0.9)
    }

    public func train<S: Sequence where S.Iterator.Element == SentenceTuple>(bitext: S, iterations: Int = 100) {
        var count: [Key: Float] = [:]
        var total: [String: Float] = [:]
        var sTotal: [String: Float] = [:]
        let bitext = !!bitext
        for iter in 1...iterations {
            // Re-initialization
            count.removeAll(keepingCapacity: true)
            total.removeAll(keepingCapacity: true)
            sTotal.removeAll(keepingCapacity: true)

            for (f, e) in bitext {
                // Compute normalization
                for ej in e {
                    sTotal[ej] = 0.0
                    for fi in f {
                        let pair: Key = [ej, fi]
                        sTotal[ej] = (sTotal[ej] ?? 0.0) + (trans[pair] ?? initialTrans)
                    }
                }
                // Collect counts
                for ej in e {
                    for fi in f {
                        let pair: Key = [ej, fi]
                        let transProb = trans[pair] ?? initialTrans
                        let ejTotal = sTotal[ej]!
                        count[pair] = (count[pair] ?? 0.0) + transProb / ejTotal
                        total[fi] = (total[fi] ?? 0.0) + transProb / ejTotal
                    }
                }
            }
            // Update translation probability
            for pair in count.keys {
                self.trans[pair] = count[pair]! / total[pair[1]]!
            }
        }
    }

    /**
     Compute alignment for a sentence pair

     - parameter eSentence: source tokenized sentence
     - parameter fSentence: destination tokenized sentence

     - returns: alignment dictionary
     */
    public func align(fSentence: [String], eSentence: [String]) -> [Int: Int] {
        var alignment: [Int: Int] = [:]
        for (j, ej) in eSentence.enumerated() {
            for (i, fi) in fSentence.enumerated() {
                let probability = trans[[ej, fi]] ?? initialTrans
                if probability >= threshold {
                    alignment[i] = j
                }
            }
        }
        return alignment
    }

}
