import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "Build", "Frameworks"],
    dependencies:
    [
        .Package(url: "https://github.com/xinranmsn/CommandLine", versions: Version(2,0,0)...Version(2,2,1)),
        .Package(url: "https://github.com/xinranmsn/RedBlackTree", majorVersion: 0, minor: 1)
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
