//
//  NaiveBayes.swift
//  LangKit
//
//  Created by Richard Wei on 3/22/16.
//
//

public struct NaiveBayes<Input, Label: Hashable> {

    public typealias KeyFunc = Input -> Float

    private var classes: [Label: KeyFunc] = [:]

    public var flipped: Bool = false

    public init(classes: [Label: KeyFunc]) {
        self.classes = classes
    }

}

extension NaiveBayes {

    public mutating func add(classLabel: Label, keyFunc: KeyFunc) {
        if !classes.keys.contains(classLabel)  {
            classes[classLabel] = keyFunc
        }
    }

}

extension NaiveBayes : Classifier {

    public func classify(input: Input) -> Label? {
        return (flipped ? argmin : argmax)({ self.classes[$0]!(input) }, args: Array(classes.keys))
    }

}
