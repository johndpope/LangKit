import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "Build", "Frameworks"],
    dependencies: [
    ],
    targets: [
//        Target(
//            name: "DataStructures",
//            dependencies: []
//        ),
//        Target(
//            name: "Tokenization",
//            dependencies: []
//        ),
//        Target(
//            name: "Alignment",
//            dependencies: []
//        ),
//        Target(
//            name: "LanguageModeling",
//            dependencies: [ "Tokenization" ]
//        ),
//        Target(
//            name: "SequenceLabeling",
//            dependencies: []
//        ),
//        Target(
//            name: "Classification",
//            dependencies: [ "LanguageModeling" ]
//        ),
        Target(
            name: "LangKit"
        ),
        Target(
            name: "Demo",
            dependencies: [ "LangKit" ]
        )
    ]
)
