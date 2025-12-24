import SwiftUI
import Combine

@MainActor
class SwipeViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var showMatch = false
    @Published var matchedUser: User?
    
    private var swipedUserIds: Set<String> = []
    
    func loadUsers() {
        isLoading = true
        
        // Simulate network delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.users = User.mockUsers
            self.isLoading = false
        }
    }
    
    func handleSwipe(direction: SwipeDirection, user: User) {
        swipedUserIds.insert(user.id)
        
        switch direction {
        case .right:
            likeUser(user)
        case .left:
            passUser(user)
        case .up:
            superLikeUser(user)
        }
    }
    
    private func likeUser(_ user: User) {
        // TODO: Send like to backend
        print("Liked: \(user.name)")
        
        // Simulate match (50% chance for demo)
        if Bool.random() {
            triggerMatch(with: user)
        }
    }
    
    private func passUser(_ user: User) {
        // TODO: Record pass to backend
        print("Passed: \(user.name)")
    }
    
    private func superLikeUser(_ user: User) {
        // TODO: Send super like to backend
        print("Super Liked: \(user.name)")
        
        // Super likes always match for demo
        triggerMatch(with: user)
    }
    
    private func triggerMatch(with user: User) {
        matchedUser = user
        showMatch = true
        
        // Haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
    
    func rewind() {
        // TODO: Implement rewind (premium feature)
        print("Rewind tapped - premium feature")
    }
    
    func boost() {
        // TODO: Implement boost (premium feature)
        print("Boost tapped - premium feature")
    }
}
