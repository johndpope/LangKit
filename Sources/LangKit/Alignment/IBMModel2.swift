//
//  IBMModel2.swift
//  LangKit
//
//  Created by Richard Wei on 3/21/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

internal func ==(lhs: IBMModel2.AlignmentKey, rhs: IBMModel2.AlignmentKey) -> Bool {
    return lhs.i == rhs.i && lhs.j == rhs.j && lhs.le == rhs.le && lhs.lf == rhs.lf
}

public class IBMModel2 : IBMModel1 {

    /**
     *  Nasty hash key structure
     *  Currently NOT intended to adopt a good naming
     *  Because it needs to compare with the original IBM Model 2 algorithm
     */
    internal struct AlignmentKey : Equatable, Hashable {
        var i, j: Int?
        var le, lf: Int

        init(_ i: Int?, _ j: Int?, _ le: Int, _ lf: Int) {
            (self.i, self.j, self.le, self.lf) = (i, j, le, lf)
        }

        var hashValue: Int {
            return "\(i), \(j), \(le), \(lf)".hashValue
        }
    }

    var alignment: [AlignmentKey: Float]
    let probablize = { (key: AlignmentKey) -> Float in 1.0 / (Float(key.lf) + 1.0) }

    public override init(bitext: [SentenceTuple], probabilityThreshold threshold: Float) {
        self.alignment = [:]
        super.init(bitext: bitext, probabilityThreshold: threshold)
    }

    public override func train(iterations: Int = 100) {
        self.train(lexicalIterations: iterations, alignmentIterations: iterations)
    }

    public func train(lexicalIterations m1Iterations: Int, alignmentIterations m2Iterations: Int) {
        // Train Model 1
        super.train(iterations: m1Iterations)

        for iter in 1...m2Iterations {

            // Initialize
            var count = [WordPair: Float]()
            var total = [String: Float]()
            var countA = [AlignmentKey: Float]()
            var totalA = [AlignmentKey: Float]()

            for (f, e) in bitext {
                let (lf, le) = (f.count, e.count)
                // Compute normalization
                var sTotal = [String: Float]()
                for (j, ej) in e.enumerated() {
                    sTotal[ej] = 0
                    for (i, fi) in f.enumerated() {
                        let key = AlignmentKey(i, j, le, lf)
                        sTotal[ej] = sTotal[ej]! + trans[WordPair(ej, fi)]! * (alignment[key] ?? probablize(key))
                    }
                }
                // Collect counts
                for (j, ej) in e.enumerated() {
                    for (i, fi) in f.enumerated() {
                        let key = AlignmentKey(i, j, le, lf)
                        let totalKey = AlignmentKey(nil, j, le, lf)
                        let wordPair = WordPair(ej, fi)
                        let c = trans[wordPair]! * (alignment[key] ?? probablize(key))
                        count[wordPair] = (count[wordPair] ?? 0.0) + c
                        total[fi] = (total[fi] ?? 0.0) + c
                        countA[key] = (countA[key] ?? 0.0) + c
                        totalA[totalKey] = (totalA[totalKey] ?? 0.0) + c
                    }
                }
                // Estimate probabilities
                for pair in count.keys {
                    trans[pair] = count[pair]! / total[pair.second]!
                }
                for alignmentKey in countA.keys {
                    let totalKey = AlignmentKey(nil, alignmentKey.j, alignmentKey.le, alignmentKey.lf)
                    alignment[alignmentKey] = countA[alignmentKey]! / totalA[totalKey]!
                }
            }
            // Debug progress output
            debugPrint("\(Float(iter) / Float(m2Iterations) * 100)%")
        }
    }

    /**
     Compute alignment for a sentence pair

     - parameter eSentence: source tokenized sentence
     - parameter fSentence: destination tokenized sentence

     - returns: alignment dictionary
     */
    public override func align(fSentence: [String], eSentence: [String]) -> [Int: Int]? {
        let (lf, le) = (fSentence.count, eSentence.count)
        var vitAlignment = [Int: Int]()
        for (j, ej) in eSentence.enumerated() {
            var (maxI, maxP): (Int, Float) = (0, -1.0)
            for (i, fi) in fSentence.enumerated() {
                let t = trans[WordPair(ej, fi)] ?? initialTrans
                let alignmentKey = AlignmentKey(i, j, le, lf)
                let a = alignment[alignmentKey] ?? probablize(alignmentKey)
                let p = t * a
                if maxP < p {
                    (maxI, maxP) = (i, p)
                }
            }
            vitAlignment[j] = maxI
        }
        return vitAlignment
    }

}
