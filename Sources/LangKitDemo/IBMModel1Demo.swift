//
//  IBMModel1Demo.swift
//  LangKit
//
//  Created by Richard Wei on 4/4/16.
//
//

import Foundation
import LangKit

class IBMModel1Demo : Demo {
    
    static func run() {
        
        guard let etext = try? NSString(contentsOfFile: "Data/Demo/Alignment/hansards.e", encoding: NSUTF8StringEncoding),
            ftext = try? NSString(contentsOfFile: "Data/Demo/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
                print("Data files don't exist.")
                exit(0)
        }
        
        let sentenceCount = 100
        let iterations = 100
        let threshold: Float = 0.5
        
        // Temporary solution to the inconsistent method name change on OS X and Linux
        #if os(Linux)
        let allRawBitext = zip(
            ftext.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()),
            etext.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()))
        #else
        let allRawBitext = zip(
            ftext.componentsSeparatedByCharacters(in: NSCharacterSet.newline()),
            etext.componentsSeparatedByCharacters(in: NSCharacterSet.newline()))
        #endif
        
        let rawBitext = allRawBitext.prefix(sentenceCount)
        
        let bitext = rawBitext.map {
            ($0.0.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()),
             $0.1.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()))
        }
        
        let aligner = IBMModel1(bitext: bitext, probabilityThreshold: threshold)
        aligner.train(iterations: iterations)
        
        // Print alignment
        if let indices = aligner.alignmentIndices {
            indices.forEach { sen in
                print(sen.map { "\($0.0)-\($0.1)" }
                    .reduce("", combine: { acc, s in acc + " " + s }))
            }
        }
    }
    
}
