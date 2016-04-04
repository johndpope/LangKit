import Foundation
import CommandLine

// Action table
let actions: [String: () -> ()] =
[
    "IBMModel1" : IBMModel1Demo.run,
    "Trie" : TrieDemo.run,
]

let cli = CommandLine()

let nameOption = StringOption(shortFlag: "n", required: true,
                              helpMessage: "[ " + actions.keys.sorted().joined(separator: " | ") + " ]")

cli.addOptions(nameOption)

// Parse args
do {
    try cli.parse()
} catch let error {
    cli.printUsage(error)
    exit(EX_USAGE)
}

// Demo name
let name = nameOption.value!

// Unknown demo, print available demos
guard let run = actions[name] else {
    print("Demo \"\(name)\" does not exist!")
    print("Available demos:")
    print("  " + actions.keys.joined(separator: "\n  "))
    exit(EX_USAGE)
}

print("Running Demo: \(name)")

// Run demo
run()