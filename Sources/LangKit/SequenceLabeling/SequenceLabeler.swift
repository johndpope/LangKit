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

    func tag(sequence: [Item]) -> [(Item, Label)]

}
