import PackageDescription

let package = Package(
    name: "LangKit",
    exclude: ["Documentation", "build", "Frameworks"],
    dependencies: [
//        .Package(url: "https://github.com/xinranmsn/Dollar", versions: Version(5,0,1)...Version(5,0,2))
    ],
    targets: [
        Target(
            name: "LangKit",
            dependencies: []
        ),
        Target(
            name: "LangKitDemo",
            dependencies: [.Target(name: "LangKit")]
        )
    ]
)
