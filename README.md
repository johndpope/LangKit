# LangKit

[![Build Status](https://travis-ci.org/xinranmsn/LangKit.svg?branch=master)](https://travis-ci.org/xinranmsn/LangKit)
[![Swift](https://img.shields.io/badge/Swift-3.0-blue.svg)](https://swift.org/download/#snapshots)
[![License](https://img.shields.io/badge/licence-UIUC-blue.svg)](https://github.com/xinranmsn/LangKit/blob/master/LICENSE)

## Natural Language Processing Toolkit in Swift

Current features:
  * HMM Part-of-Speech Tagging
  * Language Modeling

Upcoming features:
  * Word Alignment (IBM Models)
  * Data format support (ARPA LM, HMM, etc)

## Requirements

* Swift 3.0-dev 04/12/16 build (`DEVELOPMENT-SNAPSHOT-2016-04-12-a`)
  - swiftenv is strongly recommended for managing multiple versions of Swift

## Instructions

### Use LangKit in your project

Simply add a dependency in Swift Package Manager.

```
dependencies: [
    .Package(url: "https://github.com/xinranmsn/CommandLine", majorVersion: 0, minor: 1),
]
```

Then add `import LangKit` to your source file.

#### Example

* Train a part-of-speech tagger with your data
```
guard let taggedCorpus = CorpusReader(fromFile: "Data/train.txt", itemizingWith: §String.tagSplit) else {
    print("❌  Corpora error!")
    exit(EXIT_FAILURE)
}

let tagger = PartOfSpeechTagger(taggedCorpus: taggedCorpus, smoothingMode: .goodTuring)

let sentence = "Colorless green ideas sleep furiously .".tokenized()

tagger.tag(sentence) |> print
```

* Train a n-gram language model with your data
```
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

#### Xcode 7.3 with Swift 3 (OS X only) ###

Switch the toolchain to Swift development snapshot, and open `LangKit.xcodeproj`.

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
      - [ ] Absolute discounting
      - [ ] Linear interpolation
- Sequence Labeling
  - [x] Hidden Markov model
  - [x] HMM part-of-speech tagger
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
  - [ ] IBM Model 1
  - [ ] IBM Model 2
- File IO
  - [x] Corpus reader
  - [ ] ARPA LM file support
- Demo
  - [x] Language identification (`$ ./demo -n LangID`)
  - [x] HMM POS tagging (`$ ./demo -n POS`)

## Note

* Swift 2 is **not** supported.

* Earlier versions of Swift 3.0-dev may not compile due to frequent language changes.

