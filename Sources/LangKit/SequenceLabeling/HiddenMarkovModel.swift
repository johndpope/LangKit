//
//  HiddenMarkovModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import Foundation

public func ==<T>(lhs: Transition<T>, rhs: Transition<T>) -> Bool {
    return lhs.state1 == rhs.state1 && lhs.state2 == rhs.state2
}

public func ==<T, U>(lhs: Emission<T, U>, rhs: Emission<T, U>) -> Bool {
    return lhs.state == rhs.state && lhs.item == rhs.item
}

public struct Transition<T: Hashable> : Hashable {
    var state1, state2: T

    public init(_ state1: T, _ state2: T) {
        self.state1 = state1
        self.state2 = state2
    }

    public var hashValue: Int {
        return "\(state1), \(state2)".hashValue
    }
}

public struct Emission<T: Hashable, U: Hashable> : Hashable {
    var state: T
    var item: U

    public init(_ state: T, _ item: U) {
        self.state = state
        self.item = item
    }

    public var hashValue: Int {
        return "\(item), \(state)".hashValue
    }
}

public struct HiddenMarkovModel<Item: Hashable, Label: Hashable> {

//    public typealias Item = String
//    public typealias Label = String
//    public typealias Key = ArrayKey<Item>

    private var initial: [Label: Float]!
    private var transition: [Transition<Label>: Float]!
    private var emission: [Emission<Label, Item>: Float]!
    private(set) var states: Set<Label>!

    /**
     Initialize with HMM configuration

     - parameter initial:    Initial probability distribution
     - parameter transition: Transition probability distribution
     - parameter emission:   Emission probability distribution
     */
    public init(initial: [Label: Float], transition: [Transition<Label>: Float], emission: [Emission<Label, Item>: Float]) {
        self.initial = initial
        self.transition = transition
        self.emission = emission
        self.states = Set(initial.keys)
    }

    /**
     Initialize from tagged corpus

     - parameter taggedCorpus: Tagged corpus
     */
    public init<C : Sequence where C.Iterator.Element == [(Item, Label)]>(taggedCorpus corpus: C) {
        train(taggedCorpus: corpus)
    }

}

extension HiddenMarkovModel : SequenceLabelingModel {

    /**
     Train the model with tagged corpus
     
     - parameter taggedCorpus: Tagged corpus
     */
    public mutating func train<C : Sequence where C.Iterator.Element == [(Item, Label)]>(taggedCorpus corpus: C) {
        corpus.forEach { sentence in
            sentence.forEach { (token, label) in
                let key: Emission<Label, Item> = .init(label, token)
                emission[key] = (emission[key] ?? 0.0) + 1.0
            }
        }

        // TODO!
    }

    /**
     Tag an observation sequence (sentence) using Viterbi algorithm
     Complexity: O(n * |S|^2)   where S = state space

     - parameter sequence: Sentence [w0, w1, w2, ...]

     - returns: Tagged sentence [(w0, t0), (w1, t1), (w2, t2), ...]
     */
    public func tag(sequence: [Item]) -> [(item: Item, label: Label)] {
        let (_, labels) = viterbi(observation: sequence)
        return zip(sequence, labels).map{$0}
    }

}

extension HiddenMarkovModel {
    /**
     Viterbi Algorithm - Find the most likely sequence of hidden states
     A nasty implementation directly ported from Python version (needs rewriting)
     Complexity: O(n * |S|^2)   where S = state space

     - parameter observation: Observation sequence

     - returns: Most likely label sequence along with probabolity
     */
    public func viterbi(observation observation: [Item]) -> (probability: Float, label: [Label]) {
        var trellis : [[Label: Float]] = [[:]]
        var path: [Label: [Label]] = [:]
        for y in states {
            trellis[0][y] = -logf(initial[y]!) - logf(emission[Emission(y, observation[0])]!)
            path[y] = [y]
        }
        for i in 1..<observation.count {
            trellis.append([:])
            var newPath: [Label: [Label]] = [:]
            for y in states {
                var bestArg: Label!
                var bestProb: Float = FLT_MAX
                for y0 in states {
                    let prob = trellis[i-1][y0]! - logf(transition[Transition(y0, y)]!) - logf(emission[Emission(y, observation[i])]!)
                    if prob < bestProb {
                        bestArg = y0
                        bestProb = prob
                    }
                }
                trellis[i][y] = bestProb
                newPath[y] = path[bestArg]! + [y]
            }
            path = newPath
        }
        let n = observation.count - 1
        var bestArg: Label!, bestProb: Float = FLT_MAX
        for y in states where trellis[n][y] < bestProb {
            bestProb = trellis[n][y]!
            bestArg = y
        }
        return (bestProb, path[bestArg]!)
    }

}
