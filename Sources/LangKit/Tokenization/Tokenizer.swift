//
//  Tokenizer.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public extension String {
    
    public func tokenized() -> [String] {
        return characters.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    }
    
    public func lineSplit() -> [String] {
        return characters.split(omittingEmptySubsequences: true, isSeparator: ["\n", "\r"].contains).map(String.init)
    }
    
}

public class Tokenizer {
    
    public init() {
        
    }
    
}
