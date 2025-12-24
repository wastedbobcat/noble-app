# Noble - Dating App

A modern, swipeable dating app built with **SwiftUI** and **Firebase**, inspired by Tinder and Hinge.

![iOS 17+](https://img.shields.io/badge/iOS-17%2B-blue)
![Swift 5.9](https://img.shields.io/badge/Swift-5.9-orange)
![SwiftUI](https://img.shields.io/badge/SwiftUI-4.0-green)

## ✨ Features

### Core Features
- **Swipeable Cards** - Tinder-style card swiping with gesture recognition
- **Like, Pass, Super Like** - Full swipe interaction with visual feedback
- **Match System** - Instant match notifications with celebration animation
- **Real-time Chat** - Firebase-powered messaging with read receipts
- **Profile Management** - Photo uploads, bio, prompts, and interests

### User Experience
- 📱 Native SwiftUI interface optimized for iOS 17+
- 🎨 Modern gradient design with smooth animations
- 📍 Location-based matching
- 🔔 Push notifications for matches and messages
- 🔐 Phone/Apple Sign-In authentication

## 🏗️ Architecture

```
NobleApp/
├── Sources/NobleApp/
│   ├── App/
│   │   ├── NobleApp.swift          # App entry point
│   │   ├── ContentView.swift       # Root view
│   │   └── AppState.swift          # Global app state
│   ├── Models/
│   │   ├── User.swift              # User data model
│   │   ├── Match.swift             # Match & swipe models
│   │   └── Conversation.swift      # Chat models
│   ├── Views/
│   │   ├── Swipe/                  # Card swiping UI
│   │   ├── Matches/                # Matches & conversations
│   │   ├── Chat/                   # Messaging UI
│   │   ├── Profile/                # User profile
│   │   ├── Likes/                  # Who likes you
│   │   ├── Match/                  # Match celebration
│   │   ├── Onboarding/             # Sign up/login
│   │   └── Settings/               # App settings
│   ├── ViewModels/
│   │   ├── AuthViewModel.swift     # Authentication logic
│   │   └── SwipeViewModel.swift    # Swipe screen logic
│   └── Services/
│       ├── APIClient.swift         # REST API client
│       ├── UserService.swift       # User operations
│       ├── MatchService.swift      # Matching logic
│       ├── ChatService.swift       # Messaging
│       └── LocationService.swift   # Location handling
├── Tests/
├── Package.swift                   # Swift Package dependencies
└── Info.plist                      # App configuration
```

## 📦 Dependencies

| Package | Purpose |
|---------|---------|
| [Alamofire](https://github.com/Alamofire/Alamofire) | HTTP networking |
| [Nuke](https://github.com/kean/Nuke) | Image loading & caching |
| [KeychainAccess](https://github.com/kishikawakatsumi/KeychainAccess) | Secure token storage |
| [Firebase](https://github.com/firebase/firebase-ios-sdk) | Auth, Firestore, Storage |
| [Lottie](https://github.com/airbnb/lottie-ios) | Animations |

## 🚀 Getting Started

### Prerequisites
- **macOS 14+** (Sonoma)
- **Xcode 15+**
- **iOS 17+ Device or Simulator**
- **Firebase Project** (for backend)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/noble-app.git
   cd noble-app/NobleApp
   ```

2. **Open in Xcode**
   ```bash
   open Package.swift
   ```
   Or create a new Xcode project and add the package.

3. **Configure Firebase**
   - Create a project at [Firebase Console](https://console.firebase.google.com)
   - Download `GoogleService-Info.plist`
   - Add it to the Xcode project
   - Enable Authentication (Phone, Apple)
   - Create Firestore database

4. **Build & Run**
   - Select your target device/simulator
   - Press `Cmd + R` to build and run

## 🔧 Configuration

### Firebase Setup
1. Enable **Phone Authentication** in Firebase Console
2. Enable **Apple Sign-In** (requires Apple Developer account)
3. Create Firestore collections:
   - `users`
   - `swipes`
   - `matches`
   - `conversations`
4. Set up **Firebase Storage** for photo uploads

### Environment Variables
Create a `Config.swift` file (not committed to git):
```swift
enum Config {
    static let apiBaseURL = "https://your-api.com"
    static let googleMapsKey = "YOUR_KEY"
}
```

## 📱 Screenshots

| Swipe | Match | Chat | Profile |
|-------|-------|------|---------|
| Card stack with swipe gestures | Match celebration animation | Real-time messaging | Edit profile & photos |

## 🛠️ Development

### Code Style
- SwiftUI with MVVM architecture
- Async/await for concurrency
- Combine for reactive updates
- Swift Package Manager for dependencies

### Testing
```bash
# Run tests
swift test

# In Xcode
Cmd + U
```

## 📄 License

This project is licensed under the MIT License.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing`)
5. Open a Pull Request

---

Built with ❤️ using SwiftUI