//
//  HiddenMarkovModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import Foundation

public struct HiddenMarkovModel {

    public typealias Item = String
    public typealias Label = String
    public typealias Key = ArrayKey<Item>

    private var initial: [Label: Float]!
    private var transition: [Key: Float]!
    private var emission: [Key: Float]!
    private(set) var states: Set<Label>!

    public init(initial: [Label: Float], transition: [Key: Float], emission: [Key: Float]) {
        self.initial = initial
        self.transition = transition
        self.emission = emission
        self.states = Set(initial.keys)
    }

    public init<C : Sequence where C.Iterator.Element == [(Item, Label?)]>(taggedCorpus corpus: C) {
        train(taggedCorpus: corpus)
    }

}

extension HiddenMarkovModel : SequenceLabeler {

    public mutating func train<C : Sequence where C.Iterator.Element == [(Item, Label?)]>(taggedCorpus corpus: C) {
        corpus.forEach { sentence in
            sentence.forEach { (token, label) in
                let key: ArrayKey<String> = [label ?? unknown, token]
                emission[key] = (emission[key] ?? 0.0) + 1.0
            }
        }
    }

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
            trellis[0][y] = -logf(initial[y]!) - logf(emission[[y, observation[0]]]!)
            path[y] = [y]
        }
        for i in 1..<observation.count {
            trellis.append([:])
            var newPath: [Label: [Label]] = [:]
            for y in states {
                var bestArg: Label!
                var bestProb: Float = FLT_MAX
                for y0 in states {
                    let prob = trellis[i-1][y0]! - logf(transition[[y0, y]]!) - logf(emission[[y, observation[i]]]!)
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
