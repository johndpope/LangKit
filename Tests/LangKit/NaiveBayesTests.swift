//
//  NaiveBayesTests.swift
//  NaiveBayesTests
//
//  Created by Richard Wei on 3/22/16.
//
//

import XCTest
@testable import LangKit

class NaiveBayesTests: XCTestCase {
    
    func testKeyFuncClassify() {
        // Simulated probability distribution models
        let classifier = NaiveBayes(classes: [
            "1": { (_: String) -> Float in 0.2 },
            "2": { (_: String) -> Float in 0.4 },
            "3": { (_: String) -> Float in 0.1 },
            "4": { (_: String) -> Float in 0.0 }  ]
        )
        XCTAssertEqual(classifier.classify("test"), "2")
    }
    
}

extension NaiveBayesTests {
    
    static var allTests: [(String, NaiveBayesTests -> () throws -> Void)] {
        return [
            ("testKeyFuncClassify", testKeyFuncClassify)
        ]
    }
    
}