//
//  PartOfSpeechTagger.swift
//  LangKit
//
//  Created by Richard Wei on 4/14/16.
//
//

public class PartOfSpeechTagger {

    let model: HiddenMarkovModel<String, String>

    public init<C: Sequence where C.Iterator.Element == [(String, String)]>(taggedCorpus corpus: C) {
        model = HiddenMarkovModel(taggedCorpus: corpus)
    }

}

extension PartOfSpeechTagger: Tagger {

    /**
     Tag a sequence

     - parameter sequence: Sequence of items [w0, w1, w2, ...]

     - returns: [(w0, t0), (w1, t1), (w2, t2), ...]
     */
    public func tag(sequence: [String]) -> [(item: String, label: String)] {
        return model.tag(sequence)
    }

}