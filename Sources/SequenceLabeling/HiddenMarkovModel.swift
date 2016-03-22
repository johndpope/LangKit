//
//  HiddenMarkovModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public class HiddenMarkovModel {
    
    public typealias ItemType = String
    public typealias LabelType = String

    public init() {
        
    }
    
}

extension HiddenMarkovModel : SequenceLabeler {
    
    public func tag(sequence: [ItemType]) -> [(ItemType, LabelType)] {
        // TODO
        return []
    }
    
}

extension HiddenMarkovModel {
    
    public func tag(sentence: String) -> [(ItemType, LabelType)] {
        // TODO
        return []
    }
    
}