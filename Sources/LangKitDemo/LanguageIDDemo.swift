//
//  LanguageIDDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import Foundation
import struct LangKit.NgramModel
import struct LangKit.NaiveBayes

class LanguageIDDemo: Demo {

    static let englishTrain = "Data/Demo/LanguageModeling/LangId.train.English"
    static let  frenchTrain = "Data/Demo/LanguageModeling/LangId.train.French"
    static let italianTrain = "Data/Demo/LanguageModeling/LangId.train.Italian"

    /**
     Read corpora from files

     - parameter files: Array of file paths

     - returns: Corpora array
     */
    static func readCorpora(fromFiles files: [String]) -> [[[String]]] {
        var corporaRead: [[[String]]]?
        do {
            try corporaRead = files
                // Load files
                .map { path in try String(contentsOfFile: path, encoding: NSISOLatin1StringEncoding) }
                // Split sentences
                .map { $0.lineSplit().map { $0.characters.map{String($0)} } }
        }
        catch let error {
            print("❌  Read error!", error)
            exit(EXIT_FAILURE)
        }
        guard let corpora = corporaRead else {
            print("❌  Corpora empty!")
            exit(EXIT_FAILURE)
        }
        return corpora
    }

    /**
     Run demo
     */
    static func run() {
        let corpora = readCorpora(fromFiles: [englishTrain, frenchTrain, italianTrain])

        print("☢️  Training...")

        // Create and train bigram models
        let classes : [String: [String] -> Float] =
            [ "🌐  English": NgramModel(n: 3, trainingCorpus: corpora[0], smoothingMode: .goodTuring).sentenceLogProbability,
              "🌐  French" : NgramModel(n: 3, trainingCorpus: corpora[1], smoothingMode: .goodTuring).sentenceLogProbability,
              "🌐  Italian": NgramModel(n: 3, trainingCorpus: corpora[2], smoothingMode: .goodTuring).sentenceLogProbability ]

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
