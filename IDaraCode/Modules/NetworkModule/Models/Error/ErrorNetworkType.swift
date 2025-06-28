enum ErrorNetworkType: Equatable {
    case invalidResponse
    case invalidURL
    case decodingError
    case unauthorized
    case timeout
    case invalidRequest
    case notFound
    case serverError
    case emptyContent
    case unknown

    var statusCode: Int {
        switch self {
        case .invalidResponse: return 400
        case .invalidURL: return -1000
        case .decodingError: return -1002
        case .unauthorized: return 401
        case .timeout: return 408
        case .invalidRequest: return 400
        case .notFound: return 404
        case .serverError: return 500
        case .emptyContent: return 204
        case .unknown: return -1
        }
    }

    var detail: String {
        switch self {
        case .invalidResponse: return "The response was invalid."
        case .invalidURL: return "The URL provided was invalid."
        case .decodingError: return "Failed to decode the response."
        case .unauthorized: return "You are not authorized to access this resource."
        case .timeout: return "The request timed out."
        case .invalidRequest: return "The request was invalid."
        case .notFound: return "The requested resource was not found."
        case .serverError: return "The server encountered an error."
        case .emptyContent: return "The response doesn't have content."
        case .unknown: return "An unknown error occurred."
        }
    }
}
