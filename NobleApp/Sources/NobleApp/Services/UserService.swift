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
        // Mock: Return sample users for swiping
        return [
            User(
                id: "user1",
                phoneNumber: "+1111111111",
                firstName: "Sarah",
                lastName: "Johnson",
                birthDate: Calendar.current.date(byAdding: .year, value: -25, to: Date())!,
                gender: .female,
                genderPreference: .male,
                photos: ["https://picsum.photos/400/600?random=1"],
                bio: "Love hiking and photography 📸",
                occupation: "Photographer",
                education: "Art School",
                location: Location(latitude: 40.7128, longitude: -74.0060, city: "New York", state: "NY"),
                interests: ["Photography", "Hiking", "Travel"],
                isVerified: true,
                isPremium: false,
                createdAt: Date(),
                updatedAt: Date()
            ),
            User(
                id: "user2",
                phoneNumber: "+2222222222",
                firstName: "Emily",
                lastName: "Chen",
                birthDate: Calendar.current.date(byAdding: .year, value: -27, to: Date())!,
                gender: .female,
                genderPreference: .male,
                photos: ["https://picsum.photos/400/600?random=2"],
                bio: "Coffee addict ☕ Dog mom 🐕",
                occupation: "Software Engineer",
                education: "MIT",
                location: Location(latitude: 40.7128, longitude: -74.0060, city: "New York", state: "NY"),
                interests: ["Coffee", "Dogs", "Coding"],
                isVerified: true,
                isPremium: true,
                createdAt: Date(),
                updatedAt: Date()
            ),
            User(
                id: "user3",
                phoneNumber: "+3333333333",
                firstName: "Jessica",
                lastName: "Williams",
                birthDate: Calendar.current.date(byAdding: .year, value: -24, to: Date())!,
                gender: .female,
                genderPreference: .male,
                photos: ["https://picsum.photos/400/600?random=3"],
                bio: "Adventure seeker 🌍",
                occupation: "Travel Blogger",
                education: "UCLA",
                location: Location(latitude: 34.0522, longitude: -118.2437, city: "Los Angeles", state: "CA"),
                interests: ["Travel", "Writing", "Yoga"],
                isVerified: true,
                isPremium: false,
                createdAt: Date(),
                updatedAt: Date()
            )
        ]
    }
    
    func getUser(id: String) async throws -> User {
        let users = try await getUsers(page: 0, limit: 20)
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
