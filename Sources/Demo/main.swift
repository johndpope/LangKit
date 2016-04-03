import Foundation
import LangKit

guard let etext = try? String(contentsOfFile: "../../../Demo/Data/Alignment/hansards.e", encoding: NSUTF8StringEncoding),
          ftext = try? String(contentsOfFile: "../../../Demo/Data/Alignment/hansards.f", encoding: NSUTF8StringEncoding) else {
    print("Data files don't exist.")
    exit(0)
}

let sentences = 100
let iterations = 100
let threshold: Float = 0.5

let untokenizedBitext = zip( ftext.componentsSeparatedByCharacters(in: NSCharacterSet.newline()),
                             etext.componentsSeparatedByCharacters(in: NSCharacterSet.newline()))
                        .prefix(sentences)

let bitext = untokenizedBitext.map{
    ($0.0.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace()), $0.1.componentsSeparatedByCharacters(in: NSCharacterSet.whitespace())) }

for (i, (f, e)) in bitext.enumerated() {
//    print("French: \(f)\nEnglish: \(e)")
}

let aligner = IBMModel1(bitext: bitext, probabilityThreshold: threshold)
aligner.train(iterations: iterations)

// Print alignment
if let indices = aligner.alignmentIndices {
    indices.forEach { sen in
        print(sen.map { "\($0.0)-\($0.1)" }
            .reduce("", combine: { acc, s in acc + " " + s }))
    }
}
