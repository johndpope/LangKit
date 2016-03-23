//
//  Aligner.swift
//  LangKit
//
//  Created by Richard Wei on 3/23/16.
//
//

public protocol Aligner {
    
    associatedtype SentenceTuple
    
    init(bitext: [SentenceTuple])
    
    func train(iterations: Int)
    
    var alignmentIndices: [[(Int, Int)]]? { get }
    
}
