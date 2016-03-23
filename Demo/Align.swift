#!/usr/bin/env swift -I ../.build/debug -F ../.build/debug -L ../.build/debug -target x86_64-apple-macosx10.10

import Foundation
import Tokenization
import Alignment

guard let etest = try? String(contentsOfFile: "Data/Alignment/hansards.e", encoding: NSUTF8StringEncoding), ftest = try? String(contentsOfFile: "Data/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
    print("Data files don't exist.")
    exit(0)
}

let sentences = 100
let iterations = 100
let threshold = 0.9

let untokenizedBitext = zip(ftest.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()),
                            etest.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()))
                        .prefix(sentences)

let bitext = untokenizedBitext.map{ ($0.0.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), $0.1.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) }


for (i, (f, e)) in bitext.enumerate() {
    print("French: \(f)\nEnglish: \(e)")
}

let x = "I am dumb .".tokenize()
print("Tokenization: \(x)")

//let aligner = IBMModel1(bitext: bitext)
//aligner.train(100)