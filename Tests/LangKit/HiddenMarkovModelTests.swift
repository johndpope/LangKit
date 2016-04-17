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

    func testParameterInitialization() {
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

}

extension HiddenMarkovModelTests {

    static var allTests: [(String, HiddenMarkovModelTests -> () throws -> Void)] {
        return [
            ("testParameterInitialization", testParameterInitialization)
        ]
    }
    
}
