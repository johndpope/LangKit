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
    let state1, state2: T

    public init(_ state1: T, _ state2: T) {
        self.state1 = state1
        self.state2 = state2
    }

    public var hashValue: Int {
        return "\(state1), \(state2)".hashValue
    }
}

public struct Emission<T: Hashable, U: Hashable> : Hashable {
    let state: T
    let item: U

    public init(_ state: T, _ item: U) {
        self.state = state
        self.item = item
    }

    public var hashValue: Int {
        return "\(item), \(state)".hashValue
    }
}

public struct HiddenMarkovModel<Item: Hashable, Label: Hashable> {

    public typealias TransitionType = Transition<Label>
    public typealias EmissionType = Emission<Label, Item>

    private var initial: [Label: Int]
    private var transition: [TransitionType: Int]
    private var emission: [EmissionType: Int]

    // Seen items
    private var items: Set<Item>

    // State count table
    private var states: [Label: Int]

    // Total number of seen sequences
    private var sequenceCount: Int

    /**
     Initialize with HMM configuration

     - parameter initial:    Initial probability distribution
     - parameter transition: Transition probability distribution
     - parameter emission:   Emission probability distribution
     */
    public init(initial: [Label: Int],
                transition: [TransitionType: Int],
                emission: [EmissionType: Int],
                seenSequenceCount sequenceCount: Int) {
        self.initial = initial
        self.transition = transition
        self.emission = emission
        self.states = [:]
        self.sequenceCount = sequenceCount
        self.items = emission.keys.reduce(Set()) { (acc, emission) in
            acc.union([emission.item])
        }
        transition.keys.forEach { trans in
            self.states[trans.state1] = (self.states[trans.state1] ?? 0) + 1
        }
    }

    /**
     Initialize from tagged corpus

     - parameter taggedCorpus: Tagged corpus
     */
    public init<C : Sequence where C.Iterator.Element == [(Item, Label)]>(taggedCorpus corpus: C) {
        initial = [:]
        transition = [:]
        emission = [:]
        items = []
        states = [:]
        sequenceCount = 0
        train(taggedCorpus: corpus)
    }

}

// MARK: - Calculation
extension HiddenMarkovModel {

    public func initialProbability(state: Label) -> Float {
        if let count = initial[state] {
            return Float(count) / Float(sequenceCount)
        }
        return FLT_MIN
    }

    public func transitionProbability(transition: TransitionType) -> Float {
        if let count = self.transition[transition] {
            return Float(count) / Float(self.states[transition.state1]!)
        }
        return FLT_MIN
    }

    public func emissionProbability(emission: EmissionType) -> Float {
        if let count = self.emission[emission] {
            return Float(count) / Float(self.states[emission.state]!)
        }
        return FLT_MIN
    }

}

extension HiddenMarkovModel : SequenceLabelingModel {

    /**
     Train the model with tagged corpus
     Complexity: O(n^2)
     
     - parameter taggedCorpus: Tagged corpus
     */
    public mutating func train<C : Sequence where C.Iterator.Element == [(Item, Label)]>(taggedCorpus corpus: C) {
        for sentence in corpus {
            // Add initial
            let (_, head) = sentence[0]
            initial[head] = (initial[head] ?? 0) + 1
            // Collect transitions and emissions in each sentence
            for (i, (token, label)) in sentence.enumerated() {
                // Add state
                states[label] = (states[label] ?? 0) + 1

                // Add emission
                let key = Emission(label, token)
                emission[key] = (emission[key] ?? 0) + 1

                // Add seen item
                items.insert(token)

                // Add bigram transition
                if i < sentence.count - 1 {
                    let (_, nextLabel) = sentence[i+1]
                    let transKey = Transition(label, nextLabel)
                    transition[transKey] = (transition[transKey] ?? 0) + 1
                }
            }
            sequenceCount += 1
        }
    }

    /**
     Tag an observation sequence (sentence) using Viterbi algorithm
     Complexity: O(n * |S|^2)   where S = state space

     - parameter sequence: Sentence [w0, w1, w2, ...]

     - returns: Tagged sentence [(w0, t0), (w1, t1), (w2, t2), ...]
     */
    public func tag(sequence: [Item]) -> [(Item, Label)] {
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
        for y in states.keys {
            trellis[0][y] = -logf(initialProbability(y)) - logf(emissionProbability(Emission(y, observation[0])))
            path[y] = [y]
        }
        for i in 1..<observation.count {
            trellis.append([:])
            var newPath: [Label: [Label]] = [:]
            for y in states.keys {
                var bestArg: Label = states.keys.first!
                var bestProb: Float = FLT_MAX
                for y0 in states.keys {
                    let prob = trellis[i-1][y0]! - logf(transitionProbability(Transition(y0, y))) - logf(emissionProbability(Emission(y, observation[i])))
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
        for y in states.keys where trellis[n][y] < bestProb {
            bestProb = trellis[n][y]!
            bestArg = y
        }
        return (probability: bestProb, label: path[bestArg]!)
    }

}
