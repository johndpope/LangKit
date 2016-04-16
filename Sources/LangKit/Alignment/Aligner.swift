//
//  Aligner.swift
//  LangKit
//
//  Created by Richard Wei on 3/23/16.
//
//

public protocol Aligner {

    /**
     Initialize a model with a parallel corpus

     - parameter bitext: tokenized parallel corpus
     */
    init(bitext: [([String], [String])])

    /**
     Train model iteratively

     - parameter iterations: number of iterations of EM algorithm
     */
    func train(iterations: Int)

    /**
     Align two sentences

     - parameter fSentence: source sentence
     - parameter eSentence: destination sentence

     - returns: Alignment dictionary
     */
    func align(fSentence: [String], eSentence: [String]) -> [Int: Int]?

}

extension Aligner {

    public func alignmentIndices(bitext: [([String], [String])]) -> [[(Int, Int)]] {
        var indices: [[(Int, Int)]] = []
        bitext.forEach { (f, e) in
            align(fSentence: f, eSentence: e) >>- {
                indices.append(identity <^> $0.sorted(isOrderedBefore: {$0.0} • (<)))
            }
        }
        return indices
    }
}
