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
        let readers = files.map { CorpusReader(fromFile: $0, encoding: NSISOLatin1StringEncoding, tokenizingWith: {$0.characters.map{String($0)}}, itemizingWith: {$0}) }
        return readers.map {
            guard let corpus = $0 else {
                print("❌  Corpora error!")
                exit(EXIT_FAILURE)
            }
            return corpus
        }
    }

    static func probabilityFunction(fromCorpus corpus: CorpusReader<String>) -> [String] -> Float {
        return NgramModel(n: 3, trainingCorpus:
                          corpus, smoothingMode: .goodTuring,
                          counter: DictionaryNgramCounter(minimumCapacity: 1024))
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
            [ "🌐  English": probabilityFunction(fromCorpus: corpora[0]),
              "🌐  French" : probabilityFunction(fromCorpus: corpora[1]),
              "🌐  Italian": probabilityFunction(fromCorpus: corpora[2]) ]

        print("✅  Training complete")

        // Initialize classifier
        let classifier = NaiveBayes(classes: classes)

        // Interactively accept and classify sentences
        print("Now entering interactive classification")
        print("Enter a full sentence: ")

        // Interactive classification
        while true {
            // Input
            print("💬  ", terminator: "")
            guard let sentence = readLine()?.characters.map({String($0)}) else {
                continue
            }
            // Classify
            let result = classifier.classify(sentence)!
            print(result)
        }
    }
}
