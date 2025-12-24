import SwiftUI
import Combine

@MainActor
class AppState: ObservableObject {
    @Published var currentUser: User?
    @Published var matches: [Match] = []
    @Published var conversations: [Conversation] = []
    @Published var potentialMatches: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func clearError() {
        errorMessage = nil
    }
}
