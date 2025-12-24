import SwiftUI
import Combine
import KeychainAccess

@MainActor
class AuthViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var currentUser: User?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let keychain = Keychain(service: "com.noble.app")
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        checkAuthState()
    }
    
    private func checkAuthState() {
        // Mock: Check if user was previously logged in
        if let _ = try? keychain.get("userId") {
            isAuthenticated = true
            loadCurrentUser()
        }
    }
    
    func signInWithPhone(phoneNumber: String) async throws -> String {
        isLoading = true
        defer { isLoading = false }
        
        // Mock: Return a fake verification ID
        let verificationID = UUID().uuidString
        try? keychain.set(verificationID, key: "verificationID")
        return verificationID
    }
    
    func verifyCode(_ code: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let _ = try? keychain.get("verificationID") else {
            throw AuthError.missingVerificationID
        }
        
        // Mock: Simulate verification delay
        try await Task.sleep(nanoseconds: 1_000_000_000)
        
        // Mock: Create a fake user ID and save it
        let userId = UUID().uuidString
        try? keychain.set(userId, key: "userId")
        
        isAuthenticated = true
        loadCurrentUser()
    }
    
    func signOut() {
        isAuthenticated = false
        currentUser = nil
        try? keychain.removeAll()
    }
    
    private func loadCurrentUser() {
        // Mock: Use the first mock user
        currentUser = User.mockUsers.first
    }
}

enum AuthError: LocalizedError {
    case missingVerificationID
    case invalidCode
    case networkError
    
    var errorDescription: String? {
        switch self {
        case .missingVerificationID:
            return "Verification session expired. Please try again."
        case .invalidCode:
            return "Invalid verification code. Please check and try again."
        case .networkError:
            return "Network error. Please check your connection."
        }
    }
}
