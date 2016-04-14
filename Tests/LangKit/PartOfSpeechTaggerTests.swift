//
//  PartOfSpeechTaggerTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

import XCTest
@testable import LangKit

class PartOfSpeechTaggerTests: XCTestCase {

    func testSentenceTagging() {
        let sentence = "I_Noun ate_Verb a_Det banana_Noun ._.".tokenized().map{$0.tagSplit(delimiter: "_")}
        let tagger = PartOfSpeechTagger(taggedCorpus: [sentence])
        let taggedSentence = tagger.tag("I ate a banana .".tokenized())
        XCTAssertTrue(taggedSentence.elementsEqual(sentence, isEquivalent: ==))
    }

}

extension PartOfSpeechTaggerTests {

    static var allTests: [(String, PartOfSpeechTaggerTests -> () throws -> Void)] {
        return [
            ("testSentenceTagging", testSentenceTagging)
        ]
    }
    
}