//
//  LanguageIDDemo.swift
//  LangKit
//
//  Created by Richard Wei on 4/7/16.
//
//

import Foundation
import struct LangKit.NgramModel
import class LangKit.NaiveBayes

class LanguageIDDemo: Demo {
    
    static let englishTrain = "Data/Demo/LanguageModeling/LangId.train.English"
    static let  frenchTrain = "Data/Demo/LanguageModeling/LangId.train.French"
    static let italianTrain = "Data/Demo/LanguageModeling/LangId.train.Italian"
    
    /**
     Run demo
     */
    static func run() {
        var corporaRead: [[[String]]]?
        do {
            try corporaRead = [englishTrain, frenchTrain, italianTrain]
                // Load files
                .map { path in try String(contentsOfFile: path, encoding: NSISOLatin1StringEncoding) }
                // Split sentences
                .map { rawText in rawText.componentsSeparatedByCharacters(in: NSCharacterSet.newline()) }
                // Tokenize
                .map { lines in lines.map { line in line.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()) } }
        }
        catch let error {
            print("❌  Read error!", error)
            exit(EXIT_FAILURE)
        }
        guard let corpora = corporaRead else {
            print("❌  Corpora empty!")
            exit(EXIT_FAILURE)
        }
        
        // Class labels
        let classesLabels = ["English", "French", "Italian"]
        
        // Create and train ngram models
        var models = (0..<3).map { _ in NgramModel(n: 2, smoothingMode: .GoodTuring) }
        for (i, (var model, corpus)) in zip(models, corpora).enumerated() {
            model.train(corpus)
            models[i] = model
        }
        print("✅  Training complete.")
        
        // Initialize classifier
        let probabilityFunctions = models.map{$0.sentenceLogProbability}
        let classes = Dictionary(pairs: zip(classesLabels, probabilityFunctions).map{$0})
        let classifier = NaiveBayes(classes: classes)
        
        // Interactively accept and classify sentences
        print("Now entering interactive classification.")
        
        // Interactive classification
        while true {
            print("Enter a full sentence: ")
            // Input
            let inputData = NSFileHandle.withStandardInput().availableData
            guard let string = String(data: inputData, encoding: NSUTF8StringEncoding)?
                .replacingOccurrences(of: "\n", with: "") else {
                continue
            }
            // Check for quit command
            if string == ":q" {
                exit(EXIT_SUCCESS)
            }
            // Tokenize
            let sentence = string.tokenize()
            // Classify
            if let result = classifier.classify(sentence) {
                print("❕  This is \(result)")
            }
        }
    }
}

extension Dictionary {
    
    /**
     Initialize from pairs
     
     - parameter pairs: Pair array
     
     - returns: Dictionary
     */
    init(pairs: [Element]) {
        self.init()
        for (k, v) in pairs {
            self[k] = v
        }
    }
    
}
