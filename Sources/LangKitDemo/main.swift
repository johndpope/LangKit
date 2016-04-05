import Foundation
import CommandLine

// Action table
let demos: [String: () -> ()] =
[
    "IBMModel1" : { _ in IBMModelDemo.run(.One) },
    "IBMModel2" : { _ in IBMModelDemo.run(.Two) },
    "Trie"      : TrieDemo.run,
]

let cli = CommandLine()

let nameOption = StringOption(shortFlag: "n", required: true,
                              helpMessage: "[ " + demos.keys.sorted().joined(separator: " | ") + " ]")

cli.addOptions(nameOption)

// Parse args
do {
    try cli.parse()
} catch let error {
    cli.printUsage(error)
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

print("Demo n.   a demonstration of a product or technique")
print("... which means that you watch while I demonstrate.")
print("▶️  Running Demo: \(name)")

// Run demo
run()

print("⏹  Demo ended.")

