#!/usr/bin/env swift -I lib -L lib -lLangKit -target x86_64-apple-macosx10.10

/*************** LangKit Example ****************
 * This file is to demonstrate the scripting
 * ability with LangKit in Swift.
 ************************************************/

import LangKit
import Foundation

// Load parallel corpora
guard let allBitext = ParallelCorpusReader(fromFFile: "data/hansards.f",
                                           fromEFile: "data/hansards.e") else {
    print("Error reading files")
    exit(EXIT_FAILURE)
}

// Lexical translation probability threshold
let threshold: Float = 0.5
let sentenceCount = 150

// Trimmed portion of parallel corpora
let bitext = allBitext.lazy.prefix(sentenceCount)

// Train aligner
let aligner = IBMModel2(bitext: bitext, probabilityThreshold: threshold)

// Print alignment
let indices = aligner.alignmentIndices(bitext: allBitext.lazy.prefix(sentenceCount))
indices.map { sen in
    sen.map{"\($0.0)-\($0.1)"}.joined(separator: " ")
}.joined(separator: "\n") |> print
