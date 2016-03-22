//
//  LanguageModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

protocol LanguageModel {

    func train()

    func probability<T>(item: T) -> Float

}
