// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "NobleApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v10_15)
    ],
    products: [
        .executable(
            name: "NobleApp",
            targets: ["NobleApp"]
        )
    ],
    dependencies: [
        // Networking & API
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.8.0"),
        
        // Image Loading & Caching
        .package(url: "https://github.com/kean/Nuke.git", from: "12.0.0"),
        
        // Keychain Storage (for auth tokens)
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.0"),
        
        // Firebase (Auth, Firestore, Storage, Analytics)
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.0.0"),
        
        // Lottie Animations
        .package(url: "https://github.com/airbnb/lottie-ios.git", from: "4.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "NobleApp",
            dependencies: [
                "Alamofire",
                "Nuke",
                .product(name: "NukeUI", package: "Nuke"),
                "KeychainAccess",
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseStorage", package: "firebase-ios-sdk"),
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "Lottie", package: "lottie-ios"),
            ]
        ),
        .testTarget(
            name: "NobleAppTests",
            dependencies: ["NobleApp"]
        ),
    ]
)
