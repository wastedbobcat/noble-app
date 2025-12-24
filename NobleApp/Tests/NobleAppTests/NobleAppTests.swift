import XCTest
@testable import NobleApp

final class NobleAppTests: XCTestCase {
    
    // MARK: - User Model Tests
    
    func testUserInitialization() {
        let user = User(
            id: "test-id",
            email: "test@example.com",
            name: "Test User",
            age: 25,
            bio: "Test bio",
            photos: ["photo1.jpg"],
            location: nil,
            interests: ["Travel"],
            gender: .male,
            lookingFor: [.female],
            ageRangeMin: 20,
            ageRangeMax: 30,
            maxDistance: 25,
            prompts: [],
            isVerified: false,
            isPremium: false,
            createdAt: Date(),
            lastActive: Date()
        )
        
        XCTAssertEqual(user.id, "test-id")
        XCTAssertEqual(user.name, "Test User")
        XCTAssertEqual(user.age, 25)
        XCTAssertEqual(user.displayAge, "25")
        XCTAssertEqual(user.primaryPhoto, "photo1.jpg")
    }
    
    func testLocationDisplayLocation() {
        let location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            city: "New York",
            state: "NY"
        )
        
        XCTAssertEqual(location.displayLocation, "New York, NY")
    }
    
    func testLocationDisplayLocationCityOnly() {
        let location = Location(
            latitude: 40.7128,
            longitude: -74.0060,
            city: "New York",
            state: nil
        )
        
        XCTAssertEqual(location.displayLocation, "New York")
    }
    
    // MARK: - Swipe Direction Tests
    
    func testSwipeDirectionRawValues() {
        XCTAssertEqual(SwipeDirection.left.rawValue, "left")
        XCTAssertEqual(SwipeDirection.right.rawValue, "right")
        XCTAssertEqual(SwipeDirection.up.rawValue, "up")
    }
    
    // MARK: - Gender Tests
    
    func testGenderRawValues() {
        XCTAssertEqual(Gender.male.rawValue, "Male")
        XCTAssertEqual(Gender.female.rawValue, "Female")
        XCTAssertEqual(Gender.nonBinary.rawValue, "Non-binary")
        XCTAssertEqual(Gender.other.rawValue, "Other")
    }
    
    // MARK: - Message Type Tests
    
    func testMessageTypeRawValues() {
        XCTAssertEqual(MessageType.text.rawValue, "text")
        XCTAssertEqual(MessageType.image.rawValue, "image")
        XCTAssertEqual(MessageType.gif.rawValue, "gif")
    }
    
    // MARK: - Mock Data Tests
    
    func testMockUsersExist() {
        XCTAssertFalse(User.mockUsers.isEmpty)
        XCTAssertEqual(User.mockUsers.count, 3)
    }
    
    func testMockConversationsExist() {
        XCTAssertFalse(Conversation.mockConversations.isEmpty)
    }
}
