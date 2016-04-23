//
//  FunctionalTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

import XCTest
@testable import LangKit

class FunctionalTests: XCTestCase {

    func testBind() {
        let x: Int? = 3
        XCTAssertEqual(x >>- { $0 + 3 }, .some(6))

        let xx = [1, 2, 3, 4, 5, 6]
        XCTAssertEqual(xx >>- { [$0] }, xx)
        XCTAssertEqual(xx >>- { [$0 + 1] }, [2, 3, 4, 5, 6, 7])
    }

    func testApplicativeMap() {
        let operations = [ curry(+)(5),
                           curry(+)(6),
                           curry(+)(7) ]
        XCTAssertEqual(operations <*> [1, 2, 3], [6, 7, 8,
                                                  7, 8, 9,
                                                  8, 9, 10])
    }

    func testMap() {
        let x: Int? = 3
        XCTAssertEqual({ $0 + 3 } <^> x, 6)

        let xx = [1, 2, 3, 4, 5, 6]
        XCTAssertEqual({ $0 } <^> xx, xx)
        XCTAssertEqual({ $0 + 1 } <^> xx, [2, 3, 4, 5, 6, 7])
    }

    func testCurry() {
        let addOne = curry(+)(1)
        XCTAssertEqual(addOne(1), 2)
    }

    func testUncurry() {
        let add = uncurry({ (x: Int) in { (y: Int) in x + y }})
        XCTAssertEqual(add(1, 2), 3)
    }

    func testCompose() {
        // Unary • Unary
        let times10AndPlus5 = curry(+)(5) • curry(*)(10)
        XCTAssertEqual(times10AndPlus5(10), 105)
        // Binary • Unary
        let floatProduct: (Int, Int) -> Float = (*) • Float.init
        XCTAssertEqual(floatProduct(3, 2), 6.000)
    }

    func testMonadCompose() {
        let tokenizeAndLetterize: String -> [String] = ^String.tokenized >-> ^String.letterized
        XCTAssertEqual(["hel lo", "wor ld"] >>- tokenizeAndLetterize, ["h", "e", "l", "l", "o", "w", "o", "r", "l", "d"])
    }

}

extension FunctionalTests {

    static var allTests: [(String, FunctionalTests -> () throws -> Void)] {
        return [
        ]
    }
    
}