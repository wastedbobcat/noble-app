import Foundation

protocol UserServiceProtocol {
    func getUsers(page: Int, limit: Int) async throws -> [User]
    func getUser(id: String) async throws -> User
    func updateUser(_ user: User) async throws -> User
    func uploadPhoto(data: Data) async throws -> String
}

class UserService: UserServiceProtocol {
    static let shared = UserService()
    
    private init() {}
    
    func getUsers(page: Int = 0, limit: Int = 20) async throws -> [User] {
        // Return mock users from the User model
        return User.mockUsers
    }
    
    func getUser(id: String) async throws -> User {
        let users = User.mockUsers
        guard let user = users.first(where: { $0.id == id }) else {
            throw UserServiceError.userNotFound
        }
        return user
    }
    
    func updateUser(_ user: User) async throws -> User {
        // Mock: Just return the user
        return user
    }
    
    func uploadPhoto(data: Data) async throws -> String {
        // Mock: Return a fake URL
        return "https://picsum.photos/400/600?random=\(Int.random(in: 1...100))"
    }
    
    func updateLocation(userId: String, location: Location) async throws {
        // Mock: Do nothing
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
