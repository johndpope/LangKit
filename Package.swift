import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "build", "Frameworks"],
    dependencies: [
       // .Package(url: "https://github.com/xinranmsn/Dollar", versions: Version(5,0,1)...Version(5,0,2))
    ],
    targets: [
        Target(
            name: "Tokenization",
            dependencies: []
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
