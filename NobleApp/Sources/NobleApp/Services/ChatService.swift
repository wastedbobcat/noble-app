import Foundation

protocol ChatServiceProtocol {
    func getConversations() async throws -> [Conversation]
    func getMessages(conversationId: String) async throws -> [Message]
    func sendMessage(conversationId: String, content: String, type: MessageType) async throws -> Message
    func markAsRead(conversationId: String) async throws
}

class ChatService: ChatServiceProtocol {
    static let shared = ChatService()
    
    private init() {}
    
    private func getCurrentUserId() -> String? {
        return "mock-user-id"
    }
    
    func getConversations() async throws -> [Conversation] {
        // Mock: Return empty conversations for now
        return []
    }
    
    func getMessages(conversationId: String) async throws -> [Message] {
        // Mock: Return empty messages for now
        return []
    }
    
    func sendMessage(conversationId: String, content: String, type: MessageType) async throws -> Message {
        // Mock: Create a fake message
        return Message(
            id: UUID().uuidString,
            conversationId: conversationId,
            senderId: getCurrentUserId() ?? "",
            content: content,
            type: type,
            createdAt: Date(),
            isRead: false
        )
    }
    
    func markAsRead(conversationId: String) async throws {
        // Mock: Do nothing
    }
}

enum ChatServiceError: LocalizedError {
    case notAuthenticated
    case conversationNotFound
    case messageSendFailed
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "You must be logged in to access messages."
        case .conversationNotFound:
            return "Conversation not found."
        case .messageSendFailed:
            return "Failed to send message. Please try again."
        }
    }
}
