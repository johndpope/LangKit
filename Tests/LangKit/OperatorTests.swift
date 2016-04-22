//
//  OperatorTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/21/16.
//
//

import XCTest
@testable import LangKit

class OperatorTests: XCTestCase {

    func testInvocation() {
        let str = "Hello world !"
        let tokenizer = §String.tokenized
        XCTAssertEqual(tokenizer(str), ["Hello", "world", "!"])
    }

}

extension OperatorTests {

    static var allTests: [(String, OperatorTests -> () throws -> Void)] {
        return [
        ]
    }
    
}