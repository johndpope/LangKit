import Foundation
import CommandLine

// Action table
let demos: [String: () -> ()] =
[
    "ibm1"  : { IBMModelDemo.run(model: .one) },
    "ibm2"  : { IBMModelDemo.run(model: .two) },
    "id"    :   LanguageIDDemo.run,
    "pos"   :   POSTaggingDemo.run,
    "eval"  :   EvaluationDemo.run,
]

let cli = CommandLine()

let nameOption = StringOption(shortFlag: "n", required: true,
                              helpMessage: "[ " + demos.keys.sorted().joined(separator: " | ") + " ]")

cli.addOptions(nameOption)

// Parse args
do {
    try cli.parse()
} catch let error {
    cli.printUsage(error: error)
    exit(EXIT_FAILURE)
}

// Demo name
let name = nameOption.value!

// Unknown demo, print available demos
guard let run = demos[name] else {
    print("Demo \"\(name)\" does not exist!")
    print("Available demos:")
    print("  " + demos.keys.joined(separator: "\n  "))
    exit(EXIT_FAILURE)
}

print("============== LangKit ==============\nn. The missing NLP toolkit for Swift")
print("▶️  Running Demo: \(name)")

// Run demo
run()

print("⏹  Demo ended.")

