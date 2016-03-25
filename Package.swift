import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "build", "Frameworks"],
    dependencies: [
    ],
    targets: [
        Target(
            name: "Tokenization",
            dependencies: [ "Classification" ]
        ),
        Target(
            name: "Alignment",
            dependencies: []
        ),
        Target(
            name: "LanguageModeling",
            dependencies: [ "Tokenization" ]
        ),
        Target(
            name: "SequenceLabeling",
            dependencies: []
        ),
        Target(
            name: "Classification",
            dependencies: [ "LanguageModeling" ]
        )
    ]
)
