//
//  EvaluationDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/27/16.
//
//

import Foundation

import Foundation
import LangKit

class EvaluationDemo: Demo {

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
                                                    tokenizingWith: ^String.tokenize) }
        return readers.map {
            guard let corpus = $0 else {
                print("❌  Corpora error!")
                exit(EXIT_FAILURE)
            }
            return corpus
        }
    }

    static func probabilityFunction(fromCorpus corpus: CorpusReader<String>) -> [String] -> Float {
        return NgramModel(n: 3,
                          trainingCorpus: corpus,
                          smoothingMode: .none,
                          replacingTokensFewerThan: 5,
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
            [ "English": corpora[0] |> probabilityFunction,
              "French" : corpora[1] |> probabilityFunction,
              "Italian": corpora[2] |> probabilityFunction ]

        print("✅  Training complete")

        // Initialize classifier
        let classifier: NaiveBayes<[String], String> = NaiveBayes(classes: classes)

        guard let solutions = LineReader(fromFile: "Data/Demo/LanguageModeling/LangId.sol",
                                         encoding: NSISOLatin1StringEncoding),
                  tests = CorpusReader(fromFile: "Data/Demo/LanguageModeling/LangId.test",
                                       encoding: NSISOLatin1StringEncoding,
                                       tokenizingWith: ^String.tokenize) else {
            print("Error opening tests and solutions")
            exit(EXIT_FAILURE)
        }

        // Evaluate
        let scores = ClassifierEvaluator(classifier: classifier,
                                         tests: tests,
                                         solutions: solutions.map{$0.tokenize()[1]}).fScore()
        for c in classifier.classes {
            print("Class \(c)")
            print("  Precision: \(scores[c]!.precision * 100)%")
            print("     Recall: \(scores[c]!.recall * 100)%")
            print("    F-Score: \(scores[c]!.fScore * 100)%")
        }


    }
}