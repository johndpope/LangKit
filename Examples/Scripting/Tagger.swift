#!/usr/bin/env swift -I lib -L lib -lLangKit -target x86_64-apple-macosx10.10

/*************** LangKit Example ****************
 * This file is to demonstrate the scripting
 * ability with LangKit in Swift.
 ************************************************/

import LangKit
import Foundation

guard let taggedCorpus = CorpusReader(fromFile: "../../Data/Demo/POSTagging/train.txt",
                                      itemizingWith: §String.tagSplit) else {
    print("❌  Corpora error!")
    exit(EXIT_FAILURE)
}

print("☢️  Training...")
let tagger = PartOfSpeechTagger(taggedCorpus: taggedCorpus, smoothingMode: .goodTuring)
print("✅  Training complete")

// Interactive classification
while true {
    print("💬  ", terminator: "")
    readLine()
        >>- §String.tokenized
        >>- tagger.tag
        >>- { sentence in sentence.map{"\($0)_\($1)"}.joined(separator: " ") }
        >>- print
}

