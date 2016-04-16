//
//  POSTaggingDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

import Foundation
import LangKit

class POSTaggingDemo : Demo {

    /**
     Run demo
     */
    static func run() {
        guard let taggedCorpus = CorpusReader(fromFile: "Data/Demo/POSTagging/train.txt", itemizingWith: §String.tagSplit) else {
            print("❌  Corpora error!")
            exit(EXIT_FAILURE)
        }

        print("☢️  Training...")

        // Initialize HMM tagger
        let tagger = PartOfSpeechTagger(taggedCorpus: taggedCorpus)

        print("✅  Training complete")

        // Interactively accept and classify sentences
        print("Now entering interactive classification")
        print("Enter a full sentence: ")

        // Interactive classification
        while true {
            print("💬  ", terminator: "")
            readLine() >>- §String.tokenized >>- tagger.tag >>- {print($0)}
        }
    }
}