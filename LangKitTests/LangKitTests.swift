//
//  LangKitTests.swift
//  LangKitTests
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import XCTest
@testable import LangKit

class LangKitTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNgramGeneration() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        XCTAssertEqual(Array([1, 2, 3, 4, 5].ngrams(2)), [[1,2], [2,3], [3,4], [4,5]])
        XCTAssertEqual("I am a smart student .".ngrams(2, form: .Word).toArray(), [["I", "am"], ["am", "a"], ["a", "smart"], ["smart", "student"], ["student", "."]])
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
}
