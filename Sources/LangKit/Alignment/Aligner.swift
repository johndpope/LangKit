//
//  Aligner.swift
//  LangKit
//
//  Created by Richard Wei on 3/23/16.
//
//

public protocol Aligner {
    
    /// Parallel corpus
    var bitext: [([String], [String])] { get }
    
    /**
     Initialize a model with a parallel corpus
     
     - parameter bitext: tokenized parallel corpus
     */
    init(bitext: [([String], [String])])
    
    /**
     Train model iteratively
     
     - parameter iterations: number of iterations of EM algorithm
     */
    func train(iterations iterations: Int)
    
    /**
     Align two sentences
     
     - parameter fSentence: source sentence
     - parameter eSentence: destination sentence
     
     - returns: Alignment dictionary
     */
    func align(fSentence fSentence: [String], eSentence: [String]) -> [Int: Int]?
    
    /**
     Alignment for the entire parallel corpus
     */
    var alignmentIndices: [[(Int, Int)]]? { get }
    
}

extension Aligner {

    public var alignmentIndices: [[(Int, Int)]]? {
        var indices = [[(Int, Int)]]()
        for (f, e) in bitext {
            if let sentenceAlignment = align(fSentence: f, eSentence: e) {
                indices.append(sentenceAlignment.sort{(a, b) in a.0 < b.0})
            }
        }
        return indices.isEmpty ? nil : indices
    }
}
