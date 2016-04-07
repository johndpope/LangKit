//
//  NgramModel.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public class Preprocessor {

    // Token replacements for preprocessing
    internal static let unknown = "UNK"
    internal static let sentenceStart = "<s>"
    internal static let sentenceEnd = "</s>"

}

// MARK: - Sentence preprocessor
public extension Preprocessor {

    public class func wrapSentenceBoundary(sentence: [String]) -> [String] {
        return [sentenceStart] + sentence + [sentenceEnd]
    }

}

// MARK: - Corpus preprocessor
public extension Preprocessor {

    public class func replaceRareTokens(in corpus: [[String]], unknownThreshold threshold: Int) -> [[String]] {
        var frequency: [String: Int] = [:]
        corpus.forEach { sentence in
            sentence.forEach { token in
                frequency[token] = (frequency[token] ?? 0) + 1
            }
        }
        return corpus.map { sentence in
            sentence.map { frequency[$0]! > threshold ? $0 : unknown }
        }
    }

}
