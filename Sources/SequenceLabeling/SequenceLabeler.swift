//
//  SequenceLabeler.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

protocol SequenceLabeler {

    associatedtype ItemType
    associatedtype LabelType

    func tag(sequence: [ItemType]) -> [(ItemType, LabelType)]

}
