//
//  SequenceLabeler.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

protocol SequenceLabeler {

    typealias Item
    typealias Label

    var tag(sequence: [Item]) -> [Label]

}
