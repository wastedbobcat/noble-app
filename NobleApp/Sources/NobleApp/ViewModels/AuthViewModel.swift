import SwiftUI
import Combine
import FirebaseAuth
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
        // Check if user is already logged in
        if Auth.auth().currentUser != nil {
            isAuthenticated = true
            loadCurrentUser()
        }
    }
    
    func signInWithPhone(phoneNumber: String) async throws -> String {
        isLoading = true
        defer { isLoading = false }
        
        return try await withCheckedThrowingContinuation { continuation in
            PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { verificationID, error in
                if let error = error {
                    continuation.resume(throwing: error)
                    return
                }
                
                if let verificationID = verificationID {
                    // Store verification ID in keychain
                    try? self.keychain.set(verificationID, key: "verificationID")
                    continuation.resume(returning: verificationID)
                }
            }
        }
    }
    
    func verifyCode(_ code: String) async throws {
        isLoading = true
        defer { isLoading = false }
        
        guard let verificationID = try? keychain.get("verificationID") else {
            throw AuthError.missingVerificationID
        }
        
        let credential = PhoneAuthProvider.provider().credential(
            withVerificationID: verificationID,
            verificationCode: code
        )
        
        try await Auth.auth().signIn(with: credential)
        isAuthenticated = true
        loadCurrentUser()
    }
    
    func signInWithApple(credential: AuthCredential) async throws {
        isLoading = true
        defer { isLoading = false }
        
        try await Auth.auth().signIn(with: credential)
        isAuthenticated = true
        loadCurrentUser()
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            isAuthenticated = false
            currentUser = nil
            try? keychain.removeAll()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func loadCurrentUser() {
        // TODO: Load user profile from Firestore
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
