import Foundation

struct Conversation: Identifiable, Codable {
    let id: String
    let matchId: String
    let participants: [String]
    var lastMessage: Message?
    var unreadCount: Int
    let createdAt: Date
    var updatedAt: Date
    
    // Populated after fetch
    var otherUser: User?
}

struct Message: Identifiable, Codable {
    let id: String
    let conversationId: String
    let senderId: String
    let content: String
    let type: MessageType
    let createdAt: Date
    var isRead: Bool
    
    var isFromCurrentUser: Bool {
        // This will be determined at runtime
        false
    }
}

enum MessageType: String, Codable {
    case text
    case image
    case gif
    case audio
    case icebreaker
}

// MARK: - Mock Data
extension Conversation {
    static let mockConversations: [Conversation] = [
        Conversation(
            id: "1",
            matchId: "m1",
            participants: ["currentUser", "1"],
            lastMessage: Message(
                id: "msg1",
                conversationId: "1",
                senderId: "1",
                content: "Hey! How's your day going? 😊",
                type: .text,
                createdAt: Date().addingTimeInterval(-3600),
                isRead: false
            ),
            unreadCount: 1,
            createdAt: Date().addingTimeInterval(-86400),
            updatedAt: Date().addingTimeInterval(-3600),
            otherUser: User.mockUsers[0]
        ),
        Conversation(
            id: "2",
            matchId: "m2",
            participants: ["currentUser", "2"],
            lastMessage: Message(
                id: "msg2",
                conversationId: "2",
                senderId: "currentUser",
                content: "That restaurant sounds amazing!",
                type: .text,
                createdAt: Date().addingTimeInterval(-7200),
                isRead: true
            ),
            unreadCount: 0,
            createdAt: Date().addingTimeInterval(-172800),
            updatedAt: Date().addingTimeInterval(-7200),
            otherUser: User.mockUsers[1]
        )
    ]
}
