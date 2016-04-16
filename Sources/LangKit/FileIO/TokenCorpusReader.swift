//
//  TokenCorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/15/16.
//
//

import Foundation

public class TokenCorpusReader : CorpusReader<String> {

    public init?(fromFile path: String, sentenceSeparator: String = "\n", encoding: NSStringEncoding) {
        super.init(fromFile: path, sentenceSeparator: sentenceSeparator, encoding: encoding, tokenizingWith: §String.tokenized, itemizingWith: identity)
    }

}