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

extension Sequence where Iterator.Element == String {

    public func wrapSentenceBoundary() -> [String] {
        return [sentenceStart] + self + [sentenceEnd]
    }

    public func replaceRareTokens(minimumCount threshold: Int) -> [String] {
        var frequency: [String: Int] = [:]
        self.forEach {
            frequency[$0] = (frequency[$0] ?? 0) + 1
        }
        return self.map {
            frequency[$0]! > threshold ? $0 : unknown
        }
    }

}

extension Sequence where Iterator.Element == [String] {

    public func replaceRareTokens(minimumCount threshold: Int) -> [[String]] {
        var frequency: [String: Int] = [:]
        self.forEach {
            $0.forEach {
                frequency[$0] = (frequency[$0] ?? 0) + 1
            }
        }
        return self.map {
            $0.map {
                frequency[$0]! > threshold ? $0 : unknown
            }
        }
    }
    
}
