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

/**
 * Lazily cached hidden Markov model for sequence labeling
 */
public class HiddenMarkovModel<Item: Hashable, Label: Hashable> {

    public typealias TransitionType = Transition<Label>
    public typealias EmissionType = Emission<Label, Item>

    // Count tables
    private var initialCountTable: [Label: Int] = [:]
    private var transitionCountTable: [TransitionType: Int] = [:]
    private var emissionCountTable: [EmissionType: Int] = [:]

    // Total number of seen sequences
    private var sequenceCount: Int
    // Seen items
    private var items: Set<Item>
    // State count table
    private var states: [Label: Int] = [:]

    /// Caching probability tables
    private var initial: [Label: Float] = [:]
    private var transition: [TransitionType: Float] = [:]
    private var emission: [EmissionType: Float] = [:]

    /**
     Initialize with HMM counts

     - parameter initial:    Initial probability distribution
     - parameter transition: Transition probability distribution
     - parameter emission:   Emission probability distribution
     */
    public init(initial: [Label: Int],
                transition: [TransitionType: Int],
                emission: [EmissionType: Int],
                seenSequenceCount sequenceCount: Int) {
        self.initialCountTable = initial
        self.transitionCountTable = transition
        self.emissionCountTable = emission
        self.sequenceCount = sequenceCount
        self.items = emission.keys.reduce([]) { $0.union([$1.item]) }
        transition.keys.forEach {
            self.states <++ $0.state1
        }
    }

    /**
     Initialize from tagged corpus

     - parameter taggedCorpus: Tagged corpus
     */
    public init<C : Sequence where C.Iterator.Element == [(Item, Label)]>(taggedCorpus corpus: C) {
        initialCountTable = [:]
        transitionCountTable = [:]
        emissionCountTable = [:]
        items = []
        states = [:]
        sequenceCount = 0
        train(labeledSequences: corpus)
    }

}

// MARK: - Probability functions. Cache *mutating*
extension HiddenMarkovModel {

    public func initialProbability(state state: Label) -> Float {
        // Lookup cache
        if let prob = initial[state] {
            return prob
        }
        // Compute probability
        var prob: Float
        if let count = initialCountTable[state] {
            prob = Float(count) / Float(sequenceCount)
        }
        prob = FLT_MIN
        // Write cache
        initial[state] = prob
        return prob
    }

    public func transitionProbability(from state1: Label, to state2: Label) -> Float {
        return transitionProbability(TransitionType(state1, state2))
    }

    private func transitionProbability(transition: TransitionType) -> Float {
        // Lookup cache
        if let prob = self.transition[transition] {
            return prob
        }
        // Compute probability
        var prob: Float
        if let count = self.transitionCountTable[transition] {
            prob = Float(count) / Float(self.states[transition.state1]!)
        }
        prob = FLT_MIN
        // Write cache
        self.transition[transition] = prob
        return prob
    }

    public func emissionProbability(from state: Label, to item: Item) -> Float {
        return emissionProbability(EmissionType(state, item))
    }

    private func emissionProbability(emission: EmissionType) -> Float {
        // Lookup cache
        if let prob = self.emission[emission] {
            return prob
        }
        // Compute probability
        var prob: Float
        if let count = self.emissionCountTable[emission] {
            prob = Float(count) / Float(self.states[emission.state]!)
        }
        prob = FLT_MIN
        // Write cache
        self.emission[emission] = prob
        return prob
    }

}

extension HiddenMarkovModel : SequenceLabelingModel {

    /**
     Train the model with tagged corpus
     Available for incremental training
     Complexity: O(n^2)
     
     - parameter taggedCorpus: Tagged corpus
     */
    public func train<C : Sequence where C.Iterator.Element == [(Item, Label)]>(labeledSequences corpus: C) {
        for sentence in corpus {
            // Add initial
            let (_, head) = sentence[0]
            initialCountTable <++ head
            // Collect transitions and emissions in each sentence
            for (i, (token, label)) in sentence.enumerated() {
                // Add state
                states <++ label

                // Add emission
                emissionCountTable <++ Emission(label, token)

                // Add seen item
                items.insert(token)

                // Add bigram transition
                if i < sentence.count - 1 {
                    let (_, nextLabel) = sentence[i+1]
                    transitionCountTable <++ Transition(label, nextLabel)
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
        return !!zip(sequence, labels)
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
            trellis[0][y] = -logf(initialProbability(state: y)) - logf(emissionProbability(Emission(y, observation[0])))
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
