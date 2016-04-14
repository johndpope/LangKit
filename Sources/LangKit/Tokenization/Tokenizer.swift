//
//  Tokenizer.swift
//  LangKit
//
//  Created by Richard Wei on 3/20/16.
//  Copyright © 2016 Richard Wei. All rights reserved.
//

public extension String {

    /**
     Split by spaces

     - returns: Array of tokens
     */
    public func tokenized() -> [String] {
        return characters.split(separator: " ", omittingEmptySubsequences: true).map(String.init)
    }

    /**
     Split by line delimiters

     - returns: Array of strings
     */
    public func lineSplit() -> [String] {
        return characters.split(omittingEmptySubsequences: true, isSeparator: ["\n", "\r"].contains).map(String.init)
    }

    /**
     Split a tagged token `token_tag` into tuple (token, tag)

     - parameter delimiter: Delimiter between token and tag

     - returns: Tuple (token, tag)
     */
    public func tagSplit(delimiter: Character = "_") -> (String, String?) {
        let split = characters.split(separator: delimiter)
        guard split.count >= 2 else { return (String(split.first), nil) }
        return (String(split[0]), String(split[1]))
    }

}

