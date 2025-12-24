import Foundation

struct Match: Identifiable, Codable {
    let id: String
    let user1Id: String
    let user2Id: String
    let matchedAt: Date
    var isNew: Bool
    
    // Populated after fetch
    var matchedUser: User?
}

struct Swipe: Identifiable, Codable {
    let id: String
    let swiperId: String
    let swipedId: String
    let direction: SwipeDirection
    let createdAt: Date
}

enum SwipeDirection: String, Codable {
    case left  // Pass
    case right // Like
    case up    // Super Like
}

struct Like: Identifiable, Codable {
    let id: String
    let fromUserId: String
    let toUserId: String
    let isSuperLike: Bool
    let createdAt: Date
    var isRead: Bool
    
    // Populated after fetch
    var fromUser: User?
}
