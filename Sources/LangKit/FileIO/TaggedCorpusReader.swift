//
//  TaggedCorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

import Foundation

public class TaggedCorpusReader : CorpusReader {

    public typealias Element = [(String, String?)]

    public func next() -> Element? {
        return super.next()?.map {$0.tagSplit()}
    }

}