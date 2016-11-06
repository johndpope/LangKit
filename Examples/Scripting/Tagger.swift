#!/usr/bin/env swift -I lib -L lib -lLangKit -target x86_64-apple-macosx10.10

/*************** LangKit Example ****************
 * This file is to demonstrate the scripting
 * ability with LangKit in Swift.
 * To run this, you will need to build libraries
 * by `swift build -Xswiftc -emit-library`, and
 * put LangKit.swiftmodule and libLangKit.dylib
 * in lib/ folder.
 ************************************************/

import LangKit
import Foundation

guard let taggedCorpus = CorpusReader(fromFile: "../../Data/Demo/POSTagging/train.txt",
                                      tokenizingWith: ^String.tagTokenized) else {
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
        >>- ^String.tokenized
        >>- tagger.tag
        >>- { sentence in sentence.map{"\($0)_\($1)"}.joined(separator: " ") }
        >>- print
}

