//
//  EvaluationTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/27/16.
//
//

import Foundation

import XCTest
@testable import LangKit

class EvaluationTests: XCTestCase {

    func testFScore() {
        let english = ^String.letterized <^>
            [ "Colorless green ideas sleep furiously .",
              "My name is Richard Wei .",
              "University of Illinois is located in Urbana , Illinois ." ]
        let french = ^String.letterized <^>
            [ "idées vertes incolores dorment furieusement.",
              "Mon nom est Richard Wei .",
              "Université de l'Illinois est situé à Urbana , Illinois ." ]

        let models =
            [ "English": NgramModel(n: 2, trainingCorpus: english),
              "French" : NgramModel(n: 2, trainingCorpus: french)  ]

        let classifier = NaiveBayes(languageModels: models)

        let tests = ^String.letterized <^>
            [ "My name is to sleep furiously .",
              "University of Illinois is not at Urbana , Illinois",
              "Les universités françaises ne sont pas à Urbana ." ]

        let solutions = [ "English", "English", "French" ]
        let evaluator = ClassifierEvaluator(classifier: classifier, tests: tests, solutions: solutions)
        let fScores = evaluator.fScores()

        XCTAssertEqualWithAccuracy(fScores["English"]!.precision, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(fScores["English"]!.recall, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(fScores["English"]!.fScore, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(fScores["French"]!.precision, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(fScores["French"]!.recall, 1.0, accuracy: 0.1)
        XCTAssertEqualWithAccuracy(fScores["French"]!.fScore, 1.0, accuracy: 0.1)
    }

}

extension EvaluationTests {
    static var allTests : [(String, EvaluationTests -> () throws -> Void)] {
        return [

        ]
    }
}