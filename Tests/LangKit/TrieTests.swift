//
//  TrieTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/4/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

import XCTest
@testable import LangKit

class TrieTests: XCTestCase {
    
    func testInit() {
        let trie = Trie<String>()
        XCTAssertEqual(trie.count([]), 0)
        XCTAssertEqual(trie.count(["I", "am", "happy"]), 0)
    }
    
    func testCount() {
        let trigram1 = ["I", "am", "happy"]
        let trie = Trie<String>()
        // Empty
        XCTAssertEqual(trie.count, 0)
        // Insert
        let trie1 = trie.insert(trigram1)
        XCTAssertEqual(trie1.count(trigram1), 1)
        // Increment (re-insert)
        let trie2 = trie1.insert(trigram1)
        XCTAssertEqual(trie2.count(trigram1), 2)
    }

    func testEquate() {
        let bigram1 = ["I", "am"], bigram2 = ["am", "happy"]
        let trigram = ["I", "am", "happy"]
        let trie1 = Trie(initial: trigram)
        let trie2 = Trie(initial: bigram1)
        XCTAssertNotEqual(trie1, trie2)

        let trie3 = Trie(initial: bigram1)
        let trie3Same = Trie(initial: bigram1)
        let trie3Clone = trie3
        XCTAssertEqual(trie3, trie3Same)
        XCTAssertEqual(trie3, trie3Clone)

        let trie4 = Trie(initial: bigram2)
        XCTAssertNotEqual(trie3, trie4)
    }

    func testMatch() {
        let bigram1 = ["I", "am"], bigram2 = ["am", "happy"]
        let trigram = ["I", "am", "happy"]
        let trie1 = Trie(initial: bigram1)
        let trie2 = Trie(initial: bigram2)
        let trie3 = Trie(initial: trigram)

        XCTAssertTrue(trie1 ~= trie2)
        XCTAssertTrue(trie1 ~= trie3)

        let trie4 = Trie<String>()
        XCTAssertFalse(trie1 ~= trie4)
    }

    func testInsert() {
        let trigram1 = ["I", "am", "happy"]
        let trie = Trie<String>()

        // Insert
        let trie1 = trie.insert(trigram1)
        XCTAssertEqual(trie1.count(trigram1), 1)
        
        // Increment (re-insert)
        let trie2 = trie1.insert(trigram1)
        XCTAssertEqual(trie2.count(trigram1), 2)
    }
    
}

extension TrieTests {
    static var allTests : [(String, TrieTests -> () throws -> Void)] {
        return [
            ("testInit", testInit),
            ("testInsert", testInsert),
        ]
    }
}