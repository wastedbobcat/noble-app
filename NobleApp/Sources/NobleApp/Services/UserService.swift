import Foundation
import FirebaseFirestore

protocol UserServiceProtocol {
    func getUsers(page: Int, limit: Int) async throws -> [User]
    func getUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func uploadPhoto(data: Data) async throws -> String
}

class UserService: UserServiceProtocol {
    static let shared = UserService()
    
    private let db = Firestore.firestore()
    private let usersCollection = "users"
    
    private init() {}
    
    func getUsers(page: Int = 0, limit: Int = 20) async throws -> [User] {
        // In production, this would include:
        // - Location-based filtering
        // - Age range filtering
        // - Gender preferences
        // - Users not already swiped
        // - Distance calculations
        
        let snapshot = try await db.collection(usersCollection)
            .limit(to: limit)
            .getDocuments()
        
        return try snapshot.documents.compactMap { document in
            try document.data(as: User.self)
        }
    }
    
    func getUser(id: String) async throws -> User {
        let document = try await db.collection(usersCollection).document(id).getDocument()
        
        guard let user = try? document.data(as: User.self) else {
            throw UserServiceError.userNotFound
        }
        
        return user
    }
    
    func updateUser(_ user: User) async throws -> User {
        try db.collection(usersCollection).document(user.id).setData(from: user)
        return user
    }
    
    func uploadPhoto(data: Data) async throws -> String {
        // TODO: Implement Firebase Storage upload
        // Returns the download URL
        return ""
    }
    
    func updateLocation(userId: String, location: Location) async throws {
        try await db.collection(usersCollection).document(userId).updateData([
            "location": [
                "latitude": location.latitude,
                "longitude": location.longitude,
                "city": location.city ?? "",
                "state": location.state ?? ""
            ],
            "lastActive": FieldValue.serverTimestamp()
        ])
    }
}

enum UserServiceError: LocalizedError {
    case userNotFound
    case uploadFailed
    case updateFailed
    
    var errorDescription: String? {
        switch self {
        case .userNotFound:
            return "User not found"
        case .uploadFailed:
            return "Failed to upload photo"
        case .updateFailed:
            return "Failed to update profile"
        }
    }
}
