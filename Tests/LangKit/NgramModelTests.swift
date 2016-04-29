//
//  NgramTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import XCTest
import Foundation
@testable import LangKit

class NgramModelTests: XCTestCase {

    func testNgrams() {
        #if os(OSX)
        XCTAssertEqual(Array([1, 2, 3, 4, 5].ngrams(2)), [[1,2], [2,3], [3,4], [4,5]])
        let ngramsGenerated = !!"I am a smart student .".ngrams(2, form: .word)
        let ngrams = [["I", "am"], ["am", "a"], ["a", "smart"], ["smart", "student"], ["student", "."]]
        XCTAssertEqual(ngrams, ngramsGenerated)
        #endif
    }

    func testUnigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenize()
        let model = NgramModel(n: 1, trainingCorpus: [sentence], replacingTokensFewerThan: 0)
        XCTAssertEqualWithAccuracy(model.markovProbability(["Colorless"]), 1.0/9.0, accuracy: 0.2)
        XCTAssertEqualWithAccuracy(model.markovProbability(["ideas"]) |> logf, logf(1.0/9.0), accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.markovProbability(["<s>"]) |> logf, logf(1.0/9.0), accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.sentenceLogProbability(sentence), log(0.000000023230495), accuracy: 0.02)
    }

    func testBigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenize()
        let model = NgramModel(n: 2, trainingCorpus: [sentence, sentence], replacingTokensFewerThan: 1)
        XCTAssertEqualWithAccuracy(model.markovProbability(["Colorless", "green"]), 1.0, accuracy: 0.02)
        XCTAssertEqualWithAccuracy(model.sentenceLogProbability(sentence), 0.0, accuracy: 10.0)
    }

    func testTrigramProbability() {
        let sentence = "Colorless green ideas sleep furiously .".tokenize()
        let model = NgramModel(n: 3, trainingCorpus: [sentence, sentence], replacingTokensFewerThan: 1)
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