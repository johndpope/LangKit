import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "Build", "Frameworks"],
    dependencies: [
    ],
    targets: [
        Target(
            name: "LangKit"
        ),
        Target(
            name: "Demo",
            dependencies: [ "LangKit" ]
        )
    ]
)
