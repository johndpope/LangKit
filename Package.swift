import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "Build", "Frameworks", "Examples", "LangKit-iOS"],
    dependencies:
    [
        .Package(url: "https://github.com/xinranmsn/CommandLine", versions: Version(2,2,1)...Version(2,2,2)),
    ],
    targets:
    [
        Target(
            name: "LangKit"
        ),
        Target(
            name: "LangKitDemo",
            dependencies: [ "LangKit" ]
        )
    ]
)
