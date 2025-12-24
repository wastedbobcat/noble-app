import Foundation

struct User: Identifiable, Codable, Hashable {
    let id: String
    var email: String
    var name: String
    var age: Int
    var bio: String
    var photos: [String] // URLs
    var location: Location?
    var interests: [String]
    var gender: Gender
    var lookingFor: [Gender]
    var ageRangeMin: Int
    var ageRangeMax: Int
    var maxDistance: Int // in miles
    var prompts: [Prompt]
    var isVerified: Bool
    var isPremium: Bool
    var createdAt: Date
    var lastActive: Date
    
    var primaryPhoto: String? {
        photos.first
    }
    
    var displayAge: String {
        "\(age)"
    }
}

enum Gender: String, Codable, CaseIterable {
    case male = "Male"
    case female = "Female"
    case nonBinary = "Non-binary"
    case other = "Other"
}

struct Location: Codable, Hashable {
    var latitude: Double
    var longitude: Double
    var city: String?
    var state: String?
    
    var displayLocation: String {
        [city, state].compactMap { $0 }.joined(separator: ", ")
    }
}

struct Prompt: Identifiable, Codable, Hashable {
    let id: String
    var question: String
    var answer: String
}

// MARK: - Mock Data
extension User {
    static let mockUsers: [User] = [
        User(
            id: "1",
            email: "emma@example.com",
            name: "Emma",
            age: 26,
            bio: "Coffee enthusiast ☕️ | Dog mom 🐕 | Adventure seeker",
            photos: [
                "https://images.unsplash.com/photo-1494790108377-be9c29b29330",
                "https://images.unsplash.com/photo-1524504388940-b1c1722653e1"
            ],
            location: Location(latitude: 40.7128, longitude: -74.0060, city: "New York", state: "NY"),
            interests: ["Travel", "Photography", "Yoga", "Coffee"],
            gender: .female,
            lookingFor: [.male],
            ageRangeMin: 25,
            ageRangeMax: 35,
            maxDistance: 25,
            prompts: [
                Prompt(id: "1", question: "A life goal of mine", answer: "Visit every continent before 40"),
                Prompt(id: "2", question: "I'm looking for", answer: "Someone who can make me laugh and loves spontaneous adventures")
            ],
            isVerified: true,
            isPremium: false,
            createdAt: Date(),
            lastActive: Date()
        ),
        User(
            id: "2",
            email: "sophia@example.com",
            name: "Sophia",
            age: 24,
            bio: "Foodie | Bookworm | Sunset chaser 🌅",
            photos: [
                "https://images.unsplash.com/photo-1534528741775-53994a69daeb",
                "https://images.unsplash.com/photo-1517841905240-472988babdf9"
            ],
            location: Location(latitude: 34.0522, longitude: -118.2437, city: "Los Angeles", state: "CA"),
            interests: ["Reading", "Cooking", "Hiking", "Wine"],
            gender: .female,
            lookingFor: [.male],
            ageRangeMin: 24,
            ageRangeMax: 32,
            maxDistance: 30,
            prompts: [
                Prompt(id: "1", question: "My simple pleasures", answer: "Sunday farmers market runs and cozy coffee shop reading sessions"),
                Prompt(id: "2", question: "Dating me is like", answer: "Having a personal chef who also gives great book recommendations")
            ],
            isVerified: true,
            isPremium: true,
            createdAt: Date(),
            lastActive: Date()
        ),
        User(
            id: "3",
            email: "olivia@example.com",
            name: "Olivia",
            age: 28,
            bio: "Nurse by day 👩‍⚕️ | Dancer by night 💃",
            photos: [
                "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
                "https://images.unsplash.com/photo-1502823403499-6ccfcf4fb453"
            ],
            location: Location(latitude: 41.8781, longitude: -87.6298, city: "Chicago", state: "IL"),
            interests: ["Dancing", "Fitness", "Travel", "Music"],
            gender: .female,
            lookingFor: [.male],
            ageRangeMin: 26,
            ageRangeMax: 36,
            maxDistance: 20,
            prompts: [
                Prompt(id: "1", question: "The key to my heart is", answer: "Good music and even better conversation"),
                Prompt(id: "2", question: "Together we could", answer: "Explore hidden speakeasies and dance until sunrise")
            ],
            isVerified: false,
            isPremium: false,
            createdAt: Date(),
            lastActive: Date()
        )
    ]
}
