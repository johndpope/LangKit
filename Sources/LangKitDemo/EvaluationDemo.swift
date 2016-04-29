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

    /**
     Read corpora from files

     - parameter files: Array of file paths

     - returns: Corpora array
     */
    static func readCorpus(fromFile path: String) -> CorpusReader<String> {
        guard let reader = TokenCorpusReader(fromFile: path,
                                             encoding: NSISOLatin1StringEncoding,
                                             tokenizingWith: ^String.tokenize) else {
            print("❌  Corpora error!")
            exit(EXIT_FAILURE)
        }
        return reader
    }

    static func createModel(fromCorpus corpus: CorpusReader<String>) -> NgramModel {
        return NgramModel(n: 2,
                          trainingCorpus: corpus,
                          smoothingMode: .none,
                          replacingTokensFewerThan: 5,
                          counter: DictionaryNgramCounter(minimumCapacity: 10240))
    }

    static func average(_ numbers: [Float]) -> Float {
        return numbers.reduce(0.0, combine: +) / Float(numbers.count)
    }

    /**
     Run demo
     */
    static func run() {
        let englishCorpus = readCorpus(fromFile: "Data/Demo/LanguageModeling/LangId.train.English")
        let  frenchCorpus = readCorpus(fromFile: "Data/Demo/LanguageModeling/LangId.train.French")
        let italianCorpus = readCorpus(fromFile: "Data/Demo/LanguageModeling/LangId.train.Italian")

        print("☢️  Training...")

        // Create and train bigram models
        let models =
            [ "English": englishCorpus |> createModel,
              "French" : frenchCorpus  |> createModel,
              "Italian": italianCorpus |> createModel ]

        print("✅  Training complete")

        // Initialize classifier
        let classifier: NaiveBayes<[String], String> = NaiveBayes(languageModels: models)

        guard let solutions = LineReader(fromFile: "Data/Demo/LanguageModeling/LangId.sol",
                                         encoding: NSISOLatin1StringEncoding),
                      tests = CorpusReader(fromFile: "Data/Demo/LanguageModeling/LangId.test",
                                           encoding: NSISOLatin1StringEncoding,
                                           tokenizingWith: ^String.tokenize) else {
            print("Error opening tests and solutions")
            exit(EXIT_FAILURE)
        }

        // F-Score
        let scores = ClassifierEvaluator(classifier: classifier,
                                         tests: tests,
                                         solutions: solutions.map{$0.tokenize()[1]}).fScores()
        for c in classifier.classes {
            print("Class \(c)")
            print("  Precision: \(scores[c]!.precision * 100)%")
            print("     Recall: \(scores[c]!.recall * 100)%")
            print("    F-Score: \(scores[c]!.fScore * 100)%")
            let perplexity = englishCorpus.map(models[c]!.perplexity) |> average
            print(" Perplexity: \(perplexity)")
        }

    }
}