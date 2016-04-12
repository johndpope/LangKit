//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

// Token replacements for preprocessing
internal let unknown = "UNK"
internal let sentenceStart = "<s>"
internal let sentenceEnd = "</s>"

public func wrapSentenceBoundary(sentence: [String]) -> [String] {
    return [sentenceStart] + sentence + [sentenceEnd]
}

public func replaceRareTokens<C: Sequence where C.Iterator.Element == String>(in tokens: C, minimumCount threshold: Int) -> [String] {
    var frequency: [String: Int] = [:]
    tokens.forEach {
        frequency[$0] = (frequency[$0] ?? 0) + 1
    }
    return tokens.map {
        frequency[$0]! > threshold ? $0 : unknown
    }
}

