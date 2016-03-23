//
//  NaiveBayes.swift
//  LangKit
//
//  Created by Richard Wei on 3/22/16.
//
//

import LanguageModeling

public class NaiveBayes<InputType, LabelType: Hashable> {
    
    public typealias KeyFunc = InputType -> Float
    
    private var classes: [LabelType: KeyFunc]
    
    public init() {
        classes = [:]
    }
    
    public init(classes: [LabelType: KeyFunc]) {
        self.classes = classes
    }
    
}

extension NaiveBayes {
    
    public func add(classLabel: LabelType, keyFunc: KeyFunc) {
        if !classes.contains({$0.0 == classLabel})  {
            classes[classLabel] = keyFunc
        }
    }
    
}

extension NaiveBayes : Classifier {
    
    public func classify(input: InputType) -> LabelType? {
        return argmax({ self.classes[$0]!(input) }, args: Array(classes.keys))
    }
    
}