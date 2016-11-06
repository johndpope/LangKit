//
//  NaiveBayesTests.swift
//  NaiveBayesTests
//
//  Created by Richard Wei on 3/22/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import XCTest
@testable import LangKit

class NaiveBayesTests: XCTestCase {
    
    func testKeyFuncClassify() {
        // Simulated probability distribution models
        let classifier = NaiveBayes<String, String>(
            probabilityFunctions:
            [ "1": { _ in 0.2 },
              "2": { _ in 0.4 },
              "3": { _ in 0.1 },
              "4": { _ in 0.0 }  ]
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