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
        return String.init <^> characters.split(separator: " ", omittingEmptySubsequences: true)
    }

    /**
     Split by line delimiters

     - returns: Array of strings
     */
    public func lineSplit() -> [String] {
        return String.init <^> characters.split(omittingEmptySubsequences: true, isSeparator: ["\n", "\r"].contains)
    }

    /**
     Split a tagged token `token_tag` into tuple (token, tag)

     - parameter delimiter: Delimiter between token and tag

     - returns: Tuple (token, tag)
     */
    public func tagSplit(delimiter delimiter: Character = "_") -> (String, String) {
        let split = characters.split(separator: delimiter)
        guard split.count >= 2 else {
            return (String(split.first), unknown)
        }
        return (String(split[0]), String(split[1]))
    }

}

