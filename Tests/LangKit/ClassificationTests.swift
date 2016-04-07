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
        XCTAssertEqual(argmax({$0.characters.count}, args: ["a", "ab", "abc"]), "abc")
    }

    func testArgmin() {
        XCTAssertEqual(argmin({$0.characters.count}, args: ["a", "ab", "abc"]), "a")
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