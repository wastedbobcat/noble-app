import Foundation
import Alamofire

protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T
}

class APIClient: APIClientProtocol {
    static let shared = APIClient()
    
    private let baseURL = "https://api.noble-app.com/v1"
    private let session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 30
        configuration.timeoutIntervalForResource = 60
        
        session = Session(configuration: configuration)
    }
    
    func request<T: Decodable>(_ endpoint: APIEndpoint) async throws -> T {
        let url = baseURL + endpoint.path
        
        return try await withCheckedThrowingContinuation { continuation in
            session.request(
                url,
                method: endpoint.method,
                parameters: endpoint.parameters,
                encoding: endpoint.encoding,
                headers: endpoint.headers
            )
            .validate()
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    continuation.resume(returning: value)
                case .failure(let error):
                    continuation.resume(throwing: APIError.from(error))
                }
            }
        }
    }
}

enum APIEndpoint {
    case getUsers(page: Int, limit: Int)
    case getUser(id: String)
    case updateUser(id: String, data: [String: Any])
    case swipe(userId: String, direction: String)
    case getMatches
    case getConversations
    case getMessages(conversationId: String)
    case sendMessage(conversationId: String, content: String)
    case getLikes
    case reportUser(userId: String, reason: String)
    case blockUser(userId: String)
    
    var path: String {
        switch self {
        case .getUsers:
            return "/users"
        case .getUser(let id):
            return "/users/\(id)"
        case .updateUser(let id, _):
            return "/users/\(id)"
        case .swipe:
            return "/swipes"
        case .getMatches:
            return "/matches"
        case .getConversations:
            return "/conversations"
        case .getMessages(let id):
            return "/conversations/\(id)/messages"
        case .sendMessage(let id, _):
            return "/conversations/\(id)/messages"
        case .getLikes:
            return "/likes"
        case .reportUser:
            return "/reports"
        case .blockUser:
            return "/blocks"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUsers, .getUser, .getMatches, .getConversations, .getMessages, .getLikes:
            return .get
        case .updateUser:
            return .patch
        case .swipe, .sendMessage, .reportUser, .blockUser:
            return .post
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getUsers(let page, let limit):
            return ["page": page, "limit": limit]
        case .updateUser(_, let data):
            return data
        case .swipe(let userId, let direction):
            return ["userId": userId, "direction": direction]
        case .sendMessage(_, let content):
            return ["content": content]
        case .reportUser(let userId, let reason):
            return ["userId": userId, "reason": reason]
        case .blockUser(let userId):
            return ["userId": userId]
        default:
            return nil
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
    
    var headers: HTTPHeaders? {
        var headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        // Add auth token if available
        // if let token = AuthManager.shared.accessToken {
        //     headers.add(.authorization(bearerToken: token))
        // }
        
        return headers
    }
}

enum APIError: LocalizedError {
    case networkError
    case unauthorized
    case notFound
    case serverError
    case decodingError
    case unknown(String)
    
    static func from(_ error: AFError) -> APIError {
        switch error {
        case .responseValidationFailed(let reason):
            if case .unacceptableStatusCode(let code) = reason {
                switch code {
                case 401:
                    return .unauthorized
                case 404:
                    return .notFound
                case 500...599:
                    return .serverError
                default:
                    return .unknown("Status code: \(code)")
                }
            }
            return .unknown(error.localizedDescription)
        case .responseSerializationFailed:
            return .decodingError
        default:
            return .networkError
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network error. Please check your connection."
        case .unauthorized:
            return "Session expired. Please log in again."
        case .notFound:
            return "Resource not found."
        case .serverError:
            return "Server error. Please try again later."
        case .decodingError:
            return "Data error. Please update the app."
        case .unknown(let message):
            return message
        }
    }
}
