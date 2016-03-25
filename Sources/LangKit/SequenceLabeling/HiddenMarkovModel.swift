//
//  HiddenMarkovModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public func ==(lhs: HiddenMarkovModel.Transition, rhs: HiddenMarkovModel.Transition) -> Bool {
    return lhs.label1 == rhs.label1 && lhs.label2 == rhs.label2
}

public func ==(lhs: HiddenMarkovModel.Emission, rhs: HiddenMarkovModel.Emission) -> Bool {
    return lhs.label == rhs.label && lhs.item == rhs.item
}

public class HiddenMarkovModel {
    
    public typealias ItemType = String
    public typealias LabelType = String
        
    
    public struct Transition : Equatable, Hashable {
        public var label1, label2: ItemType
        
        public init(label1: ItemType, label2: ItemType) {
            self.label1 = label1
            self.label2 = label2
        }
        
        public var hashValue: Int {
            return "\(label1), \(label2)".hashValue
        }
    }

    public struct Emission : Equatable, Hashable {
        public var label: ItemType
        public var item: ItemType
        
        public var hashValue: Int {
            return "\(item), \(label)".hashValue
        }
    }

    
    private(set) var initial: [LabelType: Float]
    private(set) var transition: [Transition: Float]
    private(set) var emission: [Emission: Float]

    public init(initial: [LabelType: Float], transition: [Transition: Float], emission: [Emission: Float]) {
        self.initial = initial
        self.transition = transition
        self.emission = emission
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

extension HiddenMarkovModel {
    
    public func viterbi(observation: [ItemType]) -> [(Float, LabelType)] {
        // TODO
        return []
    }
    
}