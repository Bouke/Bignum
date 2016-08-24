import PackageDescription

let package = Package(
    name: "Bignum",
    dependencies: [
        .Package(url: "https://github.com/Bouke/COpenSSL.git", majorVersion: 1),
    ]
)
