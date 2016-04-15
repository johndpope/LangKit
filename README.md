# LangKit

[![Build Status](https://travis-ci.org/xinranmsn/LangKit.svg?branch=master)](https://travis-ci.org/xinranmsn/LangKit)
[![Swift](https://img.shields.io/badge/Swift-3.0-blue.svg)](https://swift.org/download/#snapshots)
[![License](https://img.shields.io/badge/licence-UIUC-blue.svg)](https://github.com/xinranmsn/LangKit/blob/master/LICENSE)

Natural Language Processing Toolkit in Swift

**Early work**

## Components


- Language Modeling
  - [x] N-gram language model
    - [x] Trie counter
    - [x] Dictionary counter
- Sequence Labeling
  - [x] Hidden Markov model
  - [x] HMM Part-of-speech tagger
  - [ ] Maximum-entropy Markov model
- Preprocessing
  - [x] Basics
- Tokenization
  - [x] Basics
  - [ ] Penn Treebank tokenizer
- [ ] Classification
  - [x] Naive Bayes
  - [ ] Support Vector Machine
- Alignment
  - [x] IBM Model 1
  - [x] IBM Model 2
- File IO
  - [x] Corpus reader
  - [ ] ARPA LM file support
- Demo
  - [x] Language identification (`$ ./demo -n LangID`)
  - [x] HMM POS Tagging (`$ ./demo -n POS`)

## Requirements

* Swift 3.0-dev 03/24/16 (`DEVELOPMENT-SNAPSHOT-2016-03-24-a`)

## Instructions

You can use Xcode 7.3 with Swift 3 dev toolchain **or** only the Swift 3 dev toolchain. ~~Xcode is recommended if you need a Playground.~~(not available until Swift 3 release version)

### Swift 3 on OS X 10.11, Ubuntu 14.04 or Ubuntu 15.10


Make sure you have added Swift 3's `bin` to `PATH`.

Build:
```
    $ swift build
```

Test:
```
    $ swift test
```
* Tests currently do not run due to a bug in SwiftPM as of 03/24/16. Please run the tests on Xcode!

### Xcode 7.3 with Swift 3 (OS X only) ###

Switch the toolchain to Swift development snapshot, and open `LangKit.xcodeproj`.

Build: `⌘b`

Test: `⌘u`

## Note

* Swift 2 is **not** supported.

* Earlier versions of Swift 3.0-dev may not compile due to frequent language changes.

