//
//  LanguageModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

protocol LanguageModel {
    
    associatedtype ItemType = String

    func train()

    func probability(item: ItemType) -> Float

}
