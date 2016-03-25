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
    
    public init(bitext: [SentenceTuple], probabilityThreshold threshold: Float) {
        self.bitext = bitext
        self.trans = [:]
        self.threshold = threshold
    }
    
    public convenience required init(bitext: [SentenceTuple]) {
        self.init(bitext: bitext, probabilityThreshold: 0.9)
    }
    
    public func train(iterations iterations: Int = 100) {
        var count = [WordPair: Float]()
        var total = [String: Float]()
        var sTotal = [String: Float]()
        for i in 1...iterations {
            // Initialization
            count.removeAll(keepCapacity: true)
            total.removeAll(keepCapacity: true)
            bitext.forEach { (f, e) in
                // Compute normalization
                e.forEach { ej in
                    sTotal[ej] = 0.0
                    f.forEach { fi in
                        let pair = WordPair(ej, fi)
                        sTotal[ej] = self.trans[pair] ?? initialTrans
                    }
                }
                // Collect counts
                e.forEach { ej in
                    f.forEach { fi in
                        let pair = WordPair(ej, fi)
                        let transProb = self.trans[pair] ?? initialTrans
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
            debugPrint("\(Float(i) / Float(iterations) * 100)%")
        }
    }
    
    /**
     Compute alignment for a sentence pair
     
     - parameter eSentence: source tokenized sentence
     - parameter fSentence: destination tokenized sentence
     
     - returns: alignment dictionary
     */
    public func align(fSentence fSentence: [String], eSentence: [String]) -> [Int: Int]? {
        if trans.isEmpty { return nil }
        var alignment = [Int: Int]()
        for (j, ej) in eSentence.enumerate() {
            for (i, fi) in fSentence.enumerate() {
                guard let probability = trans[WordPair(ej, fi)] else {
                    return nil
                }
                if probability >= threshold {
                    alignment[i] = j
                }
            }
        }
        return alignment
    }
    

    
}