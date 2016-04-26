//
//  HiddenMarkovModelTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

import XCTest
@testable import struct LangKit.Transition
@testable import struct LangKit.Emission
@testable import class LangKit.HiddenMarkovModel

class HiddenMarkovModelTests: XCTestCase {

    func testCountInitialization() {
        let initial = [ "Rainy": 50, "Sunny": 50 ]
        let transition = [
            Transition("Rainy", "Sunny"): 30,
            Transition("Sunny", "Rainy"): 10,
            Transition("Sunny", "Sunny"): 40,
            Transition("Rainy", "Rainy"): 20,
        ]
        let emission = [
           Emission("Rainy", "walk"): 21,
           Emission("Rainy", "shop"): 34,
           Emission("Rainy", "clean"): 25,
           Emission("Sunny", "walk"): 40,
           Emission("Sunny", "shop"): 20,
           Emission("Sunny", "clean"): 10,
        ]

        let model = HiddenMarkovModel(initialCountTable: initial, transitionCountTable: transition, emissionCountTable: emission, seenSequenceCount: 150)

        let taggedSequence = model.tag(["clean", "walk", "shop"]).map{$0.1}
        XCTAssertTrue(taggedSequence.elementsEqual(["Rainy", "Sunny", "Sunny"]))
    }

    func testProbabilityInitialization() {
        let initial: [String: Float] = [ "Rainy": 0.6, "Sunny": 0.4 ]
        let transition: [Transition<String>: Float] = [ Transition("Rainy", "Rainy"): 0.7,
                                                        Transition("Rainy", "Sunny"): 0.3,
                                                        Transition("Sunny", "Rainy"): 0.4,
                                                        Transition("Sunny", "Sunny"): 0.6 ]
        let emission: [Emission<String, String>: Float] = [ Emission("Rainy",  "walk"): 0.1,
                                                            Emission("Rainy",  "shop"): 0.4,
                                                            Emission("Rainy", "clean"): 0.5,
                                                            Emission("Sunny",  "walk"): 0.6,
                                                            Emission("Sunny",  "shop"): 0.3,
                                                            Emission("Sunny", "clean"): 0.1 ]
        let model = HiddenMarkovModel(initialProbability: initial, transitionProbability: transition, emissionProbability: emission)
        let taggedSequence = model.tag(["clean", "walk", "shop"])
        let expectedResult = [("clean", "Rainy"), ("walk", "Sunny"), ("shop", "Sunny")]
        XCTAssertTrue(taggedSequence.elementsEqual(expectedResult) {
            $0.0 == $1.0 && $0.1 == $1.1
        })
    }

}

extension HiddenMarkovModelTests {
    
    static var allTests: [(String, HiddenMarkovModelTests -> () throws -> Void)] {
        return [
        ]
    }
    
}
