//
//  LinuxMain.swift
//  LangKit
//
//  Created by Richard Wei on 4/16/16.
//
//

import XCTest

@testable import LangKitTestSuite

XCTMain([
    testCase(AlignmentTests.allTests),
    testCase(ClassificationTests.allTests),
    testCase(NgramModelTests.allTests),
    testCase(NaiveBayesTests.allTests),
    testCase(TrieTests.allTests),
    testCase(HiddenMarkovModelTests.allTests),
    testCase(PartOfSpeechTaggerTests.allTests),
    testCase(TokenizationTests.allTests),
    testCase(FunctionalTests.allTests),
])