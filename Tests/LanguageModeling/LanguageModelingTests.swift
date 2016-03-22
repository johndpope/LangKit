//
//  LanguageModelingTests.swift
//  LanguageModelingTests
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import XCTest
@testable import LanguageModeling

class LanguageModelingTests: XCTestCase {

    func testNgrams() {
        XCTAssertEqual(Array([1, 2, 3, 4, 5].ngrams(2)), [[1,2], [2,3], [3,4], [4,5]])
        XCTAssertEqual("I am a smart student .".ngrams(2, form: .Word).toArray(), [["I", "am"], ["am", "a"], ["a", "smart"], ["smart", "student"], ["student", "."]])
    }

}

extension LanguageModelingTests {

    static var allTests: [(String, LanguageModelingTests -> () throws -> Void)] {
        return [
            ("testNgrams", testNgrams)
        ]
    }

}
