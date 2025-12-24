import Foundation
import FirebaseFirestore

protocol ChatServiceProtocol {
    func getConversations() async throws -> [Conversation]
    func getMessages(conversationId: String) async throws -> [Message]
    func sendMessage(conversationId: String, content: String, type: MessageType) async throws -> Message
    func markAsRead(conversationId: String) async throws
}

class ChatService: ChatServiceProtocol {
    static let shared = ChatService()
    
    private let db = Firestore.firestore()
    private let conversationsCollection = "conversations"
    private let messagesCollection = "messages"
    
    private var messageListeners: [String: ListenerRegistration] = [:]
    
    private init() {}
    
    func getConversations() async throws -> [Conversation] {
        guard let currentUserId = getCurrentUserId() else {
            throw ChatServiceError.notAuthenticated
        }
        
        let snapshot = try await db.collection(conversationsCollection)
            .whereField("participants", arrayContains: currentUserId)
            .order(by: "updatedAt", descending: true)
            .getDocuments()
        
        var conversations = try snapshot.documents.compactMap { try $0.data(as: Conversation.self) }
        
        // Populate other user info
        for i in 0..<conversations.count {
            let otherUserId = conversations[i].participants.first { $0 != currentUserId }
            if let otherUserId = otherUserId {
                conversations[i].otherUser = try? await UserService.shared.getUser(id: otherUserId)
            }
        }
        
        return conversations
    }
    
    func getMessages(conversationId: String) async throws -> [Message] {
        let snapshot = try await db.collection(conversationsCollection)
            .document(conversationId)
            .collection(messagesCollection)
            .order(by: "createdAt", descending: false)
            .getDocuments()
        
        return try snapshot.documents.compactMap { try $0.data(as: Message.self) }
    }
    
    func sendMessage(conversationId: String, content: String, type: MessageType = .text) async throws -> Message {
        guard let currentUserId = getCurrentUserId() else {
            throw ChatServiceError.notAuthenticated
        }
        
        let message = Message(
            id: UUID().uuidString,
            conversationId: conversationId,
            senderId: currentUserId,
            content: content,
            type: type,
            createdAt: Date(),
            isRead: false
        )
        
        // Add message
        try db.collection(conversationsCollection)
            .document(conversationId)
            .collection(messagesCollection)
            .document(message.id)
            .setData(from: message)
        
        // Update conversation's last message
        try await db.collection(conversationsCollection).document(conversationId).updateData([
            "lastMessage": [
                "id": message.id,
                "content": content,
                "senderId": currentUserId,
                "createdAt": message.createdAt
            ],
            "updatedAt": FieldValue.serverTimestamp()
        ])
        
        return message
    }
    
    func markAsRead(conversationId: String) async throws {
        guard let currentUserId = getCurrentUserId() else {
            throw ChatServiceError.notAuthenticated
        }
        
        // Get unread messages not from current user
        let snapshot = try await db.collection(conversationsCollection)
            .document(conversationId)
            .collection(messagesCollection)
            .whereField("isRead", isEqualTo: false)
            .whereField("senderId", isNotEqualTo: currentUserId)
            .getDocuments()
        
        let batch = db.batch()
        
        for document in snapshot.documents {
            batch.updateData(["isRead": true], forDocument: document.reference)
        }
        
        // Reset unread count
        batch.updateData(
            ["unreadCount": 0],
            forDocument: db.collection(conversationsCollection).document(conversationId)
        )
        
        try await batch.commit()
    }
    
    func listenToMessages(conversationId: String, onUpdate: @escaping ([Message]) -> Void) {
        let listener = db.collection(conversationsCollection)
            .document(conversationId)
            .collection(messagesCollection)
            .order(by: "createdAt", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else { return }
                
                let messages = documents.compactMap { try? $0.data(as: Message.self) }
                onUpdate(messages)
            }
        
        messageListeners[conversationId] = listener
    }
    
    func stopListening(conversationId: String) {
        messageListeners[conversationId]?.remove()
        messageListeners.removeValue(forKey: conversationId)
    }
    
    private func getCurrentUserId() -> String? {
        return "currentUser"
    }
}

enum ChatServiceError: LocalizedError {
    case notAuthenticated
    case sendFailed
    case conversationNotFound
    
    var errorDescription: String? {
        switch self {
        case .notAuthenticated:
            return "Please sign in to continue"
        case .sendFailed:
            return "Failed to send message"
        case .conversationNotFound:
            return "Conversation not found"
        }
    }
}
