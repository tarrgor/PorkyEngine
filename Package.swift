import PackageDescription

let package = Package(
    name: "PorkyEngine",
    targets: [
      Target(name: "Porky", dependencies: ["PorkyEngine"])
    ],
    dependencies: [
      .Package(url: "https://github.com/tarrgor/ChessToolkit", majorVersion: 0)
    ]
)
