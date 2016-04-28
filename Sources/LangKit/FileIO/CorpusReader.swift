//
//  CorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/11/16.
//
//

import Foundation

public class CorpusReader<Item> {

    public typealias Sentence = [Item]

    // Tokenization function
    private var tokenize: String -> [Item]

    // Line reader
    public let reader: LineReader

    /**
     Initialize a CorpusReader with configurations
     
     - parameter fromFile:          File path
     - parameter sentenceSeparator: Sentence separator (default: "\n")
     - parameter encoding:          File encoding (default: UTF-8)
     - parameter tokenizingWith:    Tokenization function :: String -> [String] (default: String.tokenize)
     */
    public required init?(fromFile path: String, sentenceSeparator: String = "\n",
                          encoding: NSStringEncoding = NSUTF8StringEncoding,
                          tokenizingWith tokenize: String -> [Item]) {
        guard let reader = LineReader(fromFile: path, lineSeparator: sentenceSeparator, encoding: encoding) else {
            return nil
        }
        self.reader = reader
        self.tokenize = tokenize
    }

    /**
     Go to the beginning of the file
     */
    public func rewind() {
        reader.rewind()
    }

}

extension CorpusReader : IteratorProtocol {

    public typealias Elememnt = Sentence

    /**
     Next tokenized sentence

     - returns: Tokenized sentence
     */
    public func next() -> [Item]? {
        return reader.next() >>- tokenize
    }

}

extension CorpusReader : Sequence {

    public typealias Iterator = CorpusReader

    /**
     Make sentence iterator

     - returns: Iterator
     */
    public func makeIterator() -> Iterator {
        rewind()
        return self
    }

}

public final class TokenCorpusReader : CorpusReader<String> {

    public required init?(fromFile path: String,
                 sentenceSeparator: String = "\n",
                 encoding: NSStringEncoding = NSUTF8StringEncoding,
                 tokenizingWith tokenize: String -> [String] = ^String.tokenize) {
        super.init(fromFile: path, sentenceSeparator: sentenceSeparator, encoding: encoding, tokenizingWith: tokenize)
    }

}