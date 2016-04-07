//
//  NgramTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import XCTest
@testable import LangKit

class NgramModelTests: XCTestCase {

    func testNgrams() {
        XCTAssertEqual(Array([1, 2, 3, 4, 5].ngrams(2)), [[1,2], [2,3], [3,4], [4,5]])
        XCTAssertEqual("I am a smart student .".ngrams(2, form: .Word).toArray(), [["I", "am"], ["am", "a"], ["a", "smart"], ["smart", "student"], ["student", "."]])
    }

    func testUnigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenized()
        print(sentence)
        let model = NgramModel(n: 1, trainingCorpus: [sentence], unknownThreshold: 0)
        XCTAssertEqualWithAccuracy(model.markovProbability(["Colorless"]), 1.0/9.0, accuracy: 0.2)
        XCTAssertEqualWithAccuracy(model.markovProbability(["ideas"], logspace: true), log(1.0/9.0), accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.markovProbability(["<s>"], logspace: true), log(1.0/9.0), accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.sentenceLogProbability(sentence), log(0.000000023230495), accuracy: 0.02)
    }

    func testBigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenized()
        print(sentence)
        let model = NgramModel(n: 2, trainingCorpus: [sentence, sentence], unknownThreshold: 1)
        XCTAssertEqualWithAccuracy(model.markovProbability(["Colorless", "green"]), 1.0, accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.sentenceLogProbability(sentence), 0.0, accuracy: 10.0)
    }

    func testTrigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenized()
        print(sentence)
        let model = NgramModel(n: 3, trainingCorpus: [sentence, sentence], unknownThreshold: 1)
        XCTAssertEqualWithAccuracy(model.markovProbability(["Colorless", "green", "ideas"]), 1.0, accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.sentenceLogProbability(sentence), 0.0, accuracy: 10.0)
    }

}

extension NgramModelTests {

    static var allTests: [(String, NgramModelTests -> () throws -> Void)] {
        return [
            ("testNgrams", testNgrams),
            ("testUnigramProbability", testUnigramProbability),
            ("testBigramProbability", testBigramProbability),
            ("testTrigramProbability", testTrigramProbability),
        ]
    }
    
}