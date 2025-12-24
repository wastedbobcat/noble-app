import SwiftUI
// import FirebaseCore  // Temporarily disabled - need GoogleService-Info.plist

@main
struct NobleApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @StateObject private var appState = AppState()
    
    init() {
        // FirebaseApp.configure()  // Temporarily disabled - need GoogleService-Info.plist
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authViewModel)
                .environmentObject(appState)
        }
    }
}
