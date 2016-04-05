//
//  IBMModelDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/4/16.
//
//

import Foundation
import LangKit

class IBMModelDemo : Demo {
    
    enum Model {
        case One
        case Two
    }
    
    static func run() {
        run(.One)
    }
    
    static func run(model: Model) {
        
        guard let etext = try? NSString(contentsOfFile: "Data/Demo/Alignment/hansards.e", encoding: NSUTF8StringEncoding),
            ftext = try? NSString(contentsOfFile: "Data/Demo/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
                print("Data files don't exist.")
                exit(EXIT_FAILURE)
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
        
        #if os(Linux)
        let bitext = rawBitext.map {
            ($0.0.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()),
             $0.1.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        }
        #else
        let bitext = rawBitext.map {
            ($0.0.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()),
             $0.1.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()))
        }
        #endif
        
        let aligner: Aligner = (model == .One) ?
            IBMModel1(bitext: bitext, probabilityThreshold: threshold) :
            IBMModel2(bitext: bitext, probabilityThreshold: threshold)
        
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
