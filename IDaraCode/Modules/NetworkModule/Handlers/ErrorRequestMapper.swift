class ErrorRequestMapper: ErrorMapping {
    let specificErrors: [Int: ErrorNetworkType] = [
        400: .invalidRequest,
        401: .unauthorized,
        404: .notFound,
        408: .timeout,
        -1000: .invalidURL,
        -1001: .timeout,
        -1002: .decodingError,
        -1003: .unknown
    ]
    
    func map(statusCode: Int) -> ErrorNetworkType? {
        if (200...299).contains(statusCode) {
            return nil
        }
        
        if let error = specificErrors[statusCode] {
            return error
        }
        
        if (500...599).contains(statusCode) {
            return .serverError
        }
        
        return .unknown
    }
}
