import Foundation
import FirebaseFirestore

protocol MatchServiceProtocol {
    func swipe(userId: String, direction: SwipeDirection) async throws -> Match?
    func getMatches() async throws -> [Match]
    func getLikes() async throws -> [Like]
}

class MatchService: MatchServiceProtocol {
    static let shared = MatchService()
    
    private let db = Firestore.firestore()
    private let swipesCollection = "swipes"
    private let matchesCollection = "matches"
    private let likesCollection = "likes"
    
    private init() {}
    
    func swipe(userId: String, direction: SwipeDirection) async throws -> Match? {
        guard let currentUserId = getCurrentUserId() else {
            throw MatchServiceError.notAuthenticated
        }
        
        // Record the swipe
        let swipe = Swipe(
            id: UUID().uuidString,
            swiperId: currentUserId,
            swipedId: userId,
            direction: direction,
            createdAt: Date()
        )
        
        try db.collection(swipesCollection).document(swipe.id).setData(from: swipe)
        
        // If it's a like or super like, check for match
        if direction == .right || direction == .up {
            return try await checkForMatch(with: userId)
        }
        
        return nil
    }
    
    private func checkForMatch(with userId: String) async throws -> Match? {
        guard let currentUserId = getCurrentUserId() else {
            throw MatchServiceError.notAuthenticated
        }
        
        // Check if the other user has already liked us
        let query = db.collection(swipesCollection)
            .whereField("swiperId", isEqualTo: userId)
            .whereField("swipedId", isEqualTo: currentUserId)
            .whereField("direction", in: ["right", "up"])
        
        let snapshot = try await query.getDocuments()
        
        if !snapshot.documents.isEmpty {
            // It's a match!
            let match = Match(
                id: UUID().uuidString,
                user1Id: currentUserId,
                user2Id: userId,
                matchedAt: Date(),
                isNew: true
            )
            
            try db.collection(matchesCollection).document(match.id).setData(from: match)
            
            // Create conversation
            try await createConversation(for: match)
            
            return match
        }
        
        return nil
    }
    
    private func createConversation(for match: Match) async throws {
        let conversation = Conversation(
            id: UUID().uuidString,
            matchId: match.id,
            participants: [match.user1Id, match.user2Id],
            lastMessage: nil,
            unreadCount: 0,
            createdAt: Date(),
            updatedAt: Date()
        )
        
        try db.collection("conversations").document(conversation.id).setData(from: conversation)
    }
    
    func getMatches() async throws -> [Match] {
        guard let currentUserId = getCurrentUserId() else {
            throw MatchServiceError.notAuthenticated
        }
        
        let snapshot = try await db.collection(matchesCollection)
            .whereField("user1Id", isEqualTo: currentUserId)
            .order(by: "matchedAt", descending: true)
            .getDocuments()
        
        let snapshot2 = try await db.collection(matchesCollection)
            .whereField("user2Id", isEqualTo: currentUserId)
            .order(by: "matchedAt", descending: true)
            .getDocuments()
        
        var matches = try snapshot.documents.compactMap { try $0.data(as: Match.self) }
        matches.append(contentsOf: try snapshot2.documents.compactMap { try $0.data(as: Match.self) })
        
        return matches.sorted { $0.matchedAt > $1.matchedAt }
    }
    
    func getLikes() async throws -> [Like] {
        guard let currentUserId = getCurrentUserId() else {
            throw MatchServiceError.notAuthenticated
        }
        
        let snapshot = try await db.collection(likesCollection)
            .whereField("toUserId", isEqualTo: currentUserId)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Like.self) }
    }
    
    private func getCurrentUserId() -> String? {
        // TODO: Get from AuthViewModel
        return "currentUser"
    }
}

enum MatchServiceError: LocalizedError {
    case notAuthenticated
    case matchFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please sign in to continue"
        case .matchFailed:
            return "Failed to process match"
        }
    }
}
