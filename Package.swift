// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "ObjectAssociation",
    products: [
        .library(
            name: "ObjectAssociation",
            targets: [
                "ObjectAssociation"
            ]
        ),
    ],
    targets: [
        .target(
            name: "ObjectAssociation",
            dependencies: [
                "ObjectAssociationRuntime"
            ]
        ),
        .target(
            name: "ObjectAssociationRuntime",
            dependencies: [
                "ObjectAssociationRuntimeC"
            ]
        ),
        .target(
            name: "ObjectAssociationRuntimeC",
            dependencies: [
                "SwiftRetain"
            ]
        ),
        .target(
            name: "SwiftRetain"
        ),
        .testTarget(
            name: "ObjectAssociationTests",
            dependencies: [
                "ObjectAssociation",
                "ObjectAssociationRuntime"
            ]
        ),
    ],
    cLanguageStandard: .c17,
    cxxLanguageStandard: .cxx17
)
