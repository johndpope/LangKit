//
//  LanguageIDDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import Foundation
import LangKit

class LanguageIDDemo: Demo {

    static let englishTrain = "Data/Demo/LanguageModeling/LangId.train.English"
    static let  frenchTrain = "Data/Demo/LanguageModeling/LangId.train.French"
    static let italianTrain = "Data/Demo/LanguageModeling/LangId.train.Italian"

    /**
     Read corpora from files

     - parameter files: Array of file paths

     - returns: Corpora array
     */
    static func readCorpora(fromFiles files: [String]) -> [CorpusReader<String>] {
        let readers = files.map { TokenCorpusReader(fromFile: $0,
                                                    encoding: NSISOLatin1StringEncoding,
                                                    tokenizingWith: ^String.tokenized) }
        return readers.map {
            guard let corpus = $0 else {
                print("❌  Corpora error!")
                exit(EXIT_FAILURE)
            }
            return corpus
        }
    }

    static func probabilityFunction(fromCorpus corpus: CorpusReader<String>) -> [String] -> Float {
        return NgramModel(n: 2,
                          trainingCorpus: corpus,
                          smoothingMode: .goodTuring,
                          replacingTokensFewerThan: 0,
                          counter: DictionaryNgramCounter(minimumCapacity: 10240))
            .sentenceLogProbability
    }

    /**
     Run demo
     */
    static func run() {
        let corpora = readCorpora(fromFiles: [englishTrain, frenchTrain, italianTrain])

        print("☢️  Training...")

        // Create and train bigram models
        let classes : [String: [String] -> Float] =
            [ "🌐  English": corpora[0] |> probabilityFunction,
              "🌐  French" : corpora[1] |> probabilityFunction,
              "🌐  Italian": corpora[2] |> probabilityFunction ]

        print("✅  Training complete")

        // Initialize classifier
        let classifier = NaiveBayes(classes: classes, flipped: true)

        // Interactively accept and classify sentences
        print("Now entering interactive classification")
        print("Enter a full sentence: ")

        // Interactive classification
        while true {
            // Input
            print("💬  ", terminator: "")
            readLine() >>- ^String.tokenized >>- classifier.classify >>- print
        }
    }
}
