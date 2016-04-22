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

}

extension FunctionalTests {

    static var allTests: [(String, FunctionalTests -> () throws -> Void)] {
        return [
        ]
    }
    
}