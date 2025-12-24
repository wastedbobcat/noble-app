import Foundation

protocol MatchServiceProtocol {
    func swipe(userId: String, direction: SwipeDirection) async throws -> Match?
    func getMatches() async throws -> [Match]
    func getLikes() async throws -> [Like]
}

class MatchService: MatchServiceProtocol {
    static let shared = MatchService()
    
    private init() {}
    
    private func getCurrentUserId() -> String? {
        return "mock-user-id"
    }
    
    func swipe(userId: String, direction: SwipeDirection) async throws -> Match? {
        guard let currentUserId = getCurrentUserId() else {
            throw MatchServiceError.notAuthenticated
        }
        
        // Mock: Randomly create a match sometimes
        if (direction == .right || direction == .up) && Bool.random() {
            let match = Match(
                id: UUID().uuidString,
                user1Id: currentUserId,
                user2Id: userId,
                matchedAt: Date(),
                isNew: true
            )
            return match
        }
        
        return nil
    }
    
    func getMatches() async throws -> [Match] {
        // Mock: Return empty matches for now
        return []
    }
    
    func getLikes() async throws -> [Like] {
        // Mock: Return some sample likes
        return [
            Like(
                id: "like1",
                likerId: "user1",
                likedId: "mock-user-id",
                isSuperLike: false,
                createdAt: Date()
            )
        ]
    }
}

enum MatchServiceError: LocalizedError {
    case notAuthenticated
    case matchFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be logged in to swipe."
        case .matchFailed:
            return "Failed to process match. Please try again."
        }
    }
}

struct Swipe: Codable {
    let id: String
    let swiperId: String
    let swipedId: String
    let direction: SwipeDirection
    let createdAt: Date
}

enum SwipeDirection: String, Codable {
    case left
    case right
    case up  // Super like
}

struct Like: Identifiable, Codable {
    let id: String
    let likerId: String
    let likedId: String
    let isSuperLike: Bool
    let createdAt: Date
}
