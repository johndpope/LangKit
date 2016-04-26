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

    func testInvoke() {
        let str = "Hello world !"
        let tokenizer = ^String.tokenize
        XCTAssertEqual(tokenizer(str), ["Hello", "world", "!"])
    }

    func testGenerate() {
        let xx = [1, 2, 3, 4, 5]
        XCTAssertEqual(!!xx, xx)

        let xxSequence = (1...5)
        XCTAssertEqual(!!xxSequence, xx)
    }

    func testOptionalArithmeticAssignment() {
        var dict = ["foo": 0, "bar": 1]
        dict["foo"] ?+= 1
        XCTAssertEqual(dict, ["foo": 1, "bar": 1])
        dict["fizz"] ?+= 2
        XCTAssertEqual(dict, ["foo": 1, "bar": 1, "fizz": 2])
    }

    func testForcedOptionalArithmeticAssignment() {
        var dict = ["foo": 0, "bar": 1]
        dict["foo"] !+= 1
        XCTAssertEqual(dict, ["foo": 1, "bar": 1])
    }

}

extension OperatorTests {

    static var allTests: [(String, OperatorTests -> () throws -> Void)] {
        return [
        ]
    }
    
}