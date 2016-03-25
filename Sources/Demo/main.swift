import Foundation
import Tokenization
import Alignment

guard let etest = try? String(contentsOfFile: "../../../Demo/Data/Alignment/hansards.e", encoding: NSUTF8StringEncoding), ftest = try? String(contentsOfFile: "../../../Demo/Data/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
    print("Data files don't exist.")
    exit(0)
}

let sentences = 100
let iterations = 100
let threshold = 0.9

let untokenizedBitext = zip(ftest.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()),
                            etest.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()))
                        .prefix(sentences)

let bitext = untokenizedBitext.map{ ($0.0.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet()), $0.1.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) }

for (i, (f, e)) in bitext.enumerate() {
//    print("French: \(f)\nEnglish: \(e)")
}

let aligner = IBMModel1(bitext: bitext, probabilityThreshold: 0.5)
aligner.train(iterations: 100)
if let indices = aligner.alignmentIndices {
    indices.forEach { sen in
        print(sen.map { "\($0.0)-\($0.1)" }
            .reduce("", combine: { acc, s in acc + " " + s }))
    }
}
