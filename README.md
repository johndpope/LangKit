# LangKit [![Build Status](https://travis-ci.org/xinranmsn/LangKit.svg?branch=master)](https://travis-ci.org/xinranmsn/LangKit)

Computational Linguistics in Swift

**In construction**

Author: Richard Wei

License: The University of Illinois/NCSA Open Source License (NCSA)

## Instructions

You can use Xcode 7.3 with Swift 3 dev toolchain **or** only the Swift 3 dev toolchain. Xcode is recommended if you need a Playground.

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
### Xcode 7.3 with Swift 3 (OS X only) ###

Switch the toolchain to Swift development snapshot, and open `LangKit.xcodeproj`.

Build: `⌘b`

Test: `⌘u`

## Note

1. Currently LangKit compiles with both Swift 2.2 and 3.0-dev toolchains. But I will not gurantee the compatibility with Swift 2. 

2. I am using Swift 3.0-dev 03/24/16 build. 

## Known Issues

1. Swift Dictionary is **incredibly slow**. I might migrate to NSDictionary, or rewrite one.
