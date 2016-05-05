# LangKit

[![Build Status](https://travis-ci.org/xinranmsn/LangKit.svg?branch=master)](https://travis-ci.org/xinranmsn/LangKit)
[![Swift](https://img.shields.io/badge/Swift-3.0-blue.svg)](https://swift.org/download/#snapshots)
[![License](https://img.shields.io/badge/licence-UIUC-blue.svg)](https://github.com/xinranmsn/LangKit/blob/master/LICENSE)

## Natural Language Processing in Swift

Current features:
  * Corpus readers
  * Part-of-Speech Tagging (HMM)
  * Language Modeling (Ngram model)
  * Classification (Naive Bayes)
  * Evaluation (F-score)
  * Word Alignment (IBM models)

Upcoming features:
  * Data format support (ARPA LM, HMM, etc)
  * Fast-align

## Requirements

* Swift 3.0-dev 2016-05-03 build (`DEVELOPMENT-SNAPSHOT-2016-04-25-a`)
  - `swiftenv` is strongly recommended as a Swift version manager

## Instructions

### Use LangKit in your project

Simply add a dependency in Swift Package Manager.

```swift
dependencies: [
    .Package(url: "https://github.com/xinranmsn/LangKit", majorVersion: 0, minor: 2),
]
```

Then add `import LangKit` to your source file.

#### Example

* Train a part-of-speech tagger with your data
```swift
guard let taggedCorpus = CorpusReader(fromFile: "Data/train.txt", tokenizingWith: ^String.tagTokenized) else {
    print("❌  Corpora error!")
    exit(EXIT_FAILURE)
}

let tagger = PartOfSpeechTagger(taggedCorpus: taggedCorpus, smoothingMode: .goodTuring)

let sentence = "Colorless green ideas sleep furiously .".tokenized()

tagger.tag(sentence) |> print
```

* Train a n-gram language model with your data
```swift
guard let corpus = TokenCorpusReader(fromFile: "Data/train.txt") else {
    print("❌  Corpora error!")
    exit(EXIT_FAILURE)
}

let model = NgramModel(n: 3,
                       trainingCorpus: corpus,
                       smoothingMode: .none,
                       counter: TrieNgramCounter())

let sentence = "Colorless green ideas sleep furiously .".tokenized()

model.sentenceLogProbability(sentence) |> print
```

* Scripting in Swift

You can script to use LangKit by adding a shebang to the Swift source. Example scripts are in `Examples/Scripting/`. Scripting in Swift is not a mature feature yet, so you'll need to build LangKit to a dynamic library.
```bash
swift build -Xswiftc -emit-library
cp LangKit.dylib .build/debug/LangKit.swiftmodule Examples/Scripting/lib/
cd Examples/Scripting/lib/
./Tagger.swift
```

This is what the shebang looks like:

```bash
#!/usr/bin/env swift -I<dir of LangKit.swiftmodule> -L<dir of LangKit.dylib> -lLangKit -target x86_64-apple-macosx10.10
```

I know. The `-target x86_64-apple-macosx10.10` doesn't really look cool.

### Develop LangKit

You can use Xcode 7.3 with Swift 3 dev toolchain **or** only the Swift 3 dev toolchain. ~~Xcode is recommended if you need a Playground.~~(not available until Swift 3 release version)

#### Swift 3 on OS X 10.11, Ubuntu 14.04 or Ubuntu 15.10

Make sure you have added Swift 3's `bin` to `PATH`.

Build:
```
    $ swift build
```

Test:
```
    $ swift test
```

The `Foundation` framework on Linux is based on `apple/swift-corelibs-foundation` but the one on OS X is not. So they may have inconsistency in naming from time to time. `Foundation` APIs on OS X usually have the latest naming, so I do not intend to maintain compatibility with the old. In case that LangKit fails to build on Linux, using a newly built version (not the snapshot) of Swift might be a better idea. By the time of WWDC I believe they'll have the naming unified!

#### Xcode 7.3 with Swift 3 (OS X only) ###

1. Generate an Xcode project by executing `swift build -X`
2. Switch the toolchain to Swift development snapshot
3. Open `LangKit.xcodeproj`

Build: `⌘b`

Test: `⌘u`

## Components

- Language Modeling
  - [x] N-gram language model
    - [x] Trie counter
    - [x] Dictionary counter
    - [x] Smoothing
      - [x] Additive
      - [x] Good Turing
    - [x] Intrinsic Evaluation
      - [x] Perplexity
    - [x] Incremental training
- Sequence Labeling
  - [x] Hidden Markov model
    - [x] Smoothing
      - [x] Additive
      - [x] Good Turing
    - [x] Incremental training
  - [x] Part-of-speech tagger
  - [ ] Maximum-entropy Markov model
- Preprocessing
  - [x] Basics
- Tokenization
  - [x] Basics
  - [ ] Penn Treebank tokenizer
- Classification
  - [x] Naive Bayes
  - [ ] Support vector machine
- Alignment
  - [x] IBM Model 1
  - [x] IBM Model 2
- Evaluation
  - [x] F-score
- File IO
  - [x] Corpus reader
  - [ ] ARPA LM file support
- Demo
  - [x] Language identification (`$ ./demo -n id`)
  - [x] HMM POS tagging (`$ ./demo -n pos`)
  - [x] IBM Model 1 and 2 (`$ ./demo -n (ibm1|ibm2)`)
  - [x] Classification Evaluation (`$ ./demo -n eval`)

## Note

* Swift 2 is **not** supported.
