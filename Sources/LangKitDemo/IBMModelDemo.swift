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

    /// Model selection
    enum Model {
        case one
        case two
    }

    /// Run default model (Model 1)
    static func run() {
        run(model: .one)
    }

    /// Run specified model
    ///
    /// - parameter model: Model selection
    static func run(model: Model) {

        // Load parallel corpora
        guard let allBitext = ParallelCorpusReader(fromFFile: "Data/Demo/Alignment/hansards.f",
                                                   fromEFile: "Data/Demo/Alignment/hansards.e") else {
            print("Error opening files")
            exit(EXIT_FAILURE)
        }

        // Lexical translation probability threshold
        let threshold: Float = 0.5

        // Trimmed portion of parallel corpora
        let bitext = allBitext.lazy.prefix(500)

        // Train aligner
        print("☢️  Training...")
        let aligner: Aligner
        switch (model) {
        case .one:
            aligner = IBMModel1(bitext: bitext, probabilityThreshold: threshold)
        case .two:
            aligner = IBMModel2(bitext: bitext, probabilityThreshold: threshold)
        }

        // Print alignment
        let indices = aligner.alignmentIndices(bitext: allBitext.lazy.prefix(500))
        indices.map { sen in
            sen.map{"\($0.0)-\($0.1)"}.joined(separator: " ")
        }.joined(separator: "\n") |> print
    }

}
