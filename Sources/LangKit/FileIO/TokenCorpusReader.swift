//
//  TokenCorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/15/16.
//
//

import Foundation

public final class TokenCorpusReader : CorpusReader<String> {

    public required init?(fromFile path: String,
                 sentenceSeparator: String = "\n",
                 encoding: NSStringEncoding = NSUTF8StringEncoding,
                 tokenizingWith tokenize: String -> [String] = ^String.tokenize) {
        super.init(fromFile: path, sentenceSeparator: sentenceSeparator, encoding: encoding, tokenizingWith: tokenize)
    }

}