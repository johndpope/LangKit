//
//  SequenceLabeler.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public protocol SequenceLabeler {

    associatedtype Item
    associatedtype Label

    mutating func train<C: Sequence where C.Iterator.Element == [(Item, Label?)]>(taggedCorpus corpus: C)

    func tag(sequence: [Item]) -> [(item: Item, label: Label)]

}
