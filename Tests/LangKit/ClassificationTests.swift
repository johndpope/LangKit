//
//  ClassificationTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import XCTest
@testable import LangKit

class ClassificationTests: XCTestCase {

    func testArgmax() {
        XCTAssertEqual(argmax(["a", "ab", "abc"], keyFunc: {$0.characters.count}), "abc")
    }

    func testArgmin() {
        XCTAssertEqual(argmin(["a", "ab", "abc"], keyFunc: {$0.characters.count}), "a")
    }
    
}

extension ClassificationTests {
    
    static var allTests: [(String, ClassificationTests -> () throws -> Void)] {
        return [
            ("testArgmax", testArgmax),
            ("testArgmin", testArgmin),
        ]
    }
    
}