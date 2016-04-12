//
//  CorpusReader.swift
//  LangKit
//
//  Created by Richard Wei on 4/11/16.
//
//

import Foundation

public class CorpusReader {

    public typealias Sentence = [String]

    let chunkSize = 4096

    let path: String
    let encoding: NSStringEncoding
    let sentenceSeparator: String
    let fileHandle: NSFileHandle

    let buffer: NSMutableData
    let delimiterData: NSData

    var tokenize: String -> [String]

    var eof: Bool

    public init?(fromFile path: String, sentenceSeparator: String = "\n",
                 encoding: NSStringEncoding = NSUTF8StringEncoding,
                 tokenizingWith tokenize: String -> [String] = {$0.tokenized()}) {
        guard let handle = NSFileHandle(forReadingAtPath: path),
              let delimiterData = sentenceSeparator.data(usingEncoding: encoding),
              let buffer = NSMutableData(capacity: chunkSize) else {
            return nil
        }
        self.path = path
        self.encoding = encoding
        self.sentenceSeparator = sentenceSeparator
        self.fileHandle = handle
        self.buffer = buffer
        self.eof = false
        self.delimiterData = delimiterData
        self.tokenize = tokenize
    }

    deinit {
        self.close()
    }

    public func close() {
        fileHandle.closeFile()
    }

    public func rewind() {
        fileHandle.seek(toFileOffset: 0)
        buffer.length = 0
        eof = false
    }

}

extension CorpusReader : IteratorProtocol {

    public typealias Elememnt = Sentence

    public func next() -> [String]? {
        if eof {
            return nil
        }
        var range = buffer.range(of: delimiterData, options: [], range: NSMakeRange(0, buffer.length))
        while range.location == NSNotFound {
            let data = fileHandle.readData(ofLength: chunkSize)
            guard data.length > 0 else {
                eof = true
                return nil
            }
            buffer.append(data)
            range = buffer.range(of: delimiterData, options: [], range: NSMakeRange(0, buffer.length))
        }

        let maybeLine = String(data: buffer.subdata(with: NSMakeRange(0, range.location)), encoding: encoding)
        buffer.replaceBytes(in: NSMakeRange(0, range.location + range.length), withBytes: nil, length: 0)

        guard let line = maybeLine else {
            return nil
        }

        return tokenize(line)
    }

}

extension CorpusReader : Sequence {

    public typealias Iterator = CorpusReader

    public func makeIterator() -> Iterator {
        self.rewind()
        return self
    }

}