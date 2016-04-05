//
//  TrieTests.swift
//  LangKit
//
//  Created by Richard Wei on 4/4/16.
//
//

import XCTest
@testable import LangKit

class TrieTests: XCTestCase {
    
    func testInit() {
        let trie = Trie<String>()
        XCTAssertEqual(trie.count([]), 0)
        XCTAssertEqual(trie.count(["I", "am", "happy"]), 0)
    }
    
    func testInsert() {
        let trie = Trie<String>()
        
        let trigram1 = ["I", "am", "happy"]
        
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
            
        ]
    }
}