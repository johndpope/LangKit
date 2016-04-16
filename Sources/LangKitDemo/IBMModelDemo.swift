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
        case one
        case two
    }

    static func run() {
        run(.one)
    }

    static func run(model: Model) {

        guard let etext = try? String(contentsOfFile: "Data/Demo/Alignment/hansards.e", encoding: NSUTF8StringEncoding),
            ftext = try? String(contentsOfFile: "Data/Demo/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
                print("Data files don't exist.")
                exit(EXIT_FAILURE)
        }

        let sentenceCount = 100
        let iterations = 100
        let threshold: Float = 0.5

        let allRawBitext = zip( ftext.lineSplit(), etext.lineSplit() )
        let rawBitext = allRawBitext.prefix(sentenceCount)
        let bitext = rawBitext.map { ($0.0.tokenized(), $0.1.tokenized()) }

        var aligner: Aligner!

        switch (model) {
        case .one:
            aligner = IBMModel1(bitext: bitext, probabilityThreshold: threshold)
        case .two:
            aligner = IBMModel2(bitext: bitext, probabilityThreshold: threshold)
        }

        aligner.train(iterations: iterations)

        // Print alignment
        let indices = aligner.alignmentIndices(bitext)
        indices.forEach { sen in
            print(sen.map { "\($0.0)-\($0.1)" }
                .reduce("", combine: { acc, s in acc + " " + s }))
        }
    }

}
