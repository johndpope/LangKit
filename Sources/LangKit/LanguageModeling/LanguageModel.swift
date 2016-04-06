//
//  LanguageModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public protocol LanguageModel {
    
    associatedtype Token
    
    associatedtype Item = [Token]

    /**
     Train the model with tokenized corpus
     
     - parameter corpus: Tokenized corpus
     */
    mutating func train(corpus: [[Token]])

    /**
     Probability of item
     
     - parameter item:     Item
     - parameter logspace: Enable logspace
    
     - returns: Probability
     */
    func probability(item: Item, logspace: Bool) -> Float
    
    /**
     Markov conditional probability of item
     
     - parameter item:     Item
     - parameter logspace: Enable logspace
     
     - returns: Probability
     */
    func markovProbability(item: Item, logspace: Bool) -> Float

}
