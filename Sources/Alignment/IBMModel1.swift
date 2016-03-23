//
//  IBMModel1.swift
//  LangKit
//
//  Created by Richard Wei on 3/21/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public func ==(lhs: WordPair, rhs: WordPair) -> Bool {
    return lhs.first == rhs.first && lhs.second == rhs.second
}

public struct WordPair : Hashable {
    public var first, second: String
    
    public var hashValue: Int {
        return "\(first), \(second)".hashValue
    }
    
    public init(_ first: String, _ second: String) {
        self.first = first
        self.second = second
    }
}

/// Classic algorithm of IBM Model 1
public class IBMModel1: Aligner {
    
    public typealias SentenceTuple = ([String], [String])
    
    var trans: [WordPair: Float]
    var bitext: [SentenceTuple]
    
    var threshold: Float
    
    let initialTrans: Float = 0.1
    
    public init(bitext: [SentenceTuple], probabilityThreshold threshold: Float) {
        self.bitext = bitext
        self.trans = [:]
        self.threshold = threshold
    }
    
    public convenience required init(bitext: [SentenceTuple]) {
        self.init(bitext: bitext, probabilityThreshold: 0.9)
    }
    
    public func train(iterations: Int = 100) {
        for _ in 1...iterations {
            var count = [WordPair: Float]()
            var total = [String: Float]()
            var sTotal = [String: Float]()
            for (f, e) in bitext {
                // Compute normalization
                for ej in e {
                    sTotal[ej] = 0.0
                    for fi in f {
                        let pair = WordPair(ej, fi)
                        sTotal[ej] = trans[pair] ?? initialTrans
                    }
                }
                // Collect counts
                for ej in e {
                    for fi in e {
                        let pair = WordPair(ej, fi)
                        count[pair] = count[pair]! + trans[pair]! / sTotal[ej]!
                        total[fi] = (total[fi] ?? 0.0) + trans[pair]! / sTotal[ej]!
                    }
                }
            }
            // Update translation probability
            for pair in count.keys {
                trans[pair] = count[pair]! / total[pair.second]!
            }
        }
    }
    
    public var alignmentIndices: [[(Int, Int)]]? {
        var alignment = [[(Int, Int)]]()
        for (s, (f, e)) in bitext.enumerate() {
            for (j, ej) in e.enumerate() {
                for (i, fi) in f.enumerate() {
                    if trans[WordPair(ej, fi)] >= threshold {
                        alignment[s].append((i, j))
                    }
                }
            }
        }
        return alignment
    }
    
}