//
//  CorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/11/16.
//
//

import Foundation

public class CorpusReader<Item> {

    public typealias Sentence = [Item]

    // Chunk size constant
    private let chunkSize = 4096

    private let path: String
    private let encoding: NSStringEncoding
    private let sentenceSeparator: String
    private let fileHandle: NSFileHandle
    private let buffer: NSMutableData
    private let delimiterData: NSData

    // Tokenization function
    private var tokenize: String -> [String]

    // Itemification function
    private var itemize: String -> Item

    // EOF state
    private var eof: Bool

    /**
     Initialize a CorpusReader with configurations
     
     - parameter fromFile:          File path
     - parameter sentenceSeparator: Sentence separator (default: "\n")
     - parameter encoding:          File encoding (default: UTF8)
     - parameter tokenizingWith:    Tokenization function :: String -> [String] (default: String.tokenize)
     */
    public init?(fromFile path: String, sentenceSeparator: String = "\n",
                 encoding: NSStringEncoding = NSUTF8StringEncoding,
                 tokenizingWith tokenize: String -> [String] = §String.tokenized,
                 itemizingWith itemize: String -> Item) {
        // Temporarily resolving Foundation inconsistency between OS X and Linux
        #if os(OSX)
        guard let handle = NSFileHandle(forReadingAtPath: path),
              let delimiterData = sentenceSeparator.data(using: encoding),
              let buffer = NSMutableData(capacity: chunkSize) else {
            return nil
        }
        #else // Linux
        guard let handle = NSFileHandle(forReadingAtPath: path),
              let delimiterData = sentenceSeparator.dataUsingEncoding(encoding),
              let buffer = NSMutableData(capacity: chunkSize) else {
            return nil
        }
        #endif
        self.path = path
        self.encoding = encoding
        self.sentenceSeparator = sentenceSeparator
        self.fileHandle = handle
        self.buffer = buffer
        self.eof = false
        self.delimiterData = delimiterData
        self.tokenize = tokenize
        self.itemize = itemize
    }

    deinit {
        self.close()
    }

    /**
     Close file
     */
    private func close() {
        fileHandle.closeFile()
    }

    /**
     Go to the beginning of the file
     */
    public func rewind() {
        #if os(OSX)
        fileHandle.seek(toFileOffset: 0)
        #else
        fileHandle.seekToFileOffset(0)
        #endif
        buffer.length = 0
        eof = false
    }

}

extension CorpusReader : IteratorProtocol {

    public typealias Elememnt = Sentence

    /**
     Next tokenized sentence

     - returns: Tokenized sentence
     */
    public func next() -> [Item]? {
        if eof {
            return nil
        }

        #if os(OSX)
        var range = buffer.range(of: delimiterData, options: [], in: NSMakeRange(0, buffer.length))
        #else
        var range = buffer.rangeOfData(delimiterData, options: [], range: NSMakeRange(0, buffer.length))
        #endif

        while range.location == NSNotFound {
            #if os(OSX)
            let data = fileHandle.readData(ofLength: chunkSize)
            #else
            let data = fileHandle.readDataOfLength(chunkSize)
            #endif
            guard data.length > 0 else {
                eof = true
                return nil
            }
            #if os(OSX)
            buffer.append(data)
            range = buffer.range(of: delimiterData, options: [], in: NSMakeRange(0, buffer.length))
            #else
            buffer.appendData(data)
            range = buffer.rangeOfData(delimiterData, options: [], range: NSMakeRange(0, buffer.length))
            #endif
        }

        #if os(OSX)
        let maybeLine = String(data: buffer.subdata(with: NSMakeRange(0, range.location)), encoding: encoding)
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        #else
        let maybeLine = String(data: buffer.subdataWithRange(NSMakeRange(0, range.location)), encoding: encoding)
        buffer.replaceBytesInRange(NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)
        #endif

        guard let line = maybeLine else {
            return nil
        }

        return itemize <^> tokenize(line)
    }

}

extension CorpusReader : Sequence {

    public typealias Iterator = CorpusReader

    /**
     Make corpus iterator

     - returns: Iterator
     */
    public func makeIterator() -> Iterator {
        self.rewind()
        return self
    }

}
