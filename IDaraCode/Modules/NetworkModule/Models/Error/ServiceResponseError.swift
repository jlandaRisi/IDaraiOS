import Foundation

struct ServiceResponseError: Error {
    let errorType: ErrorNetworkType
    var errorResponse: ErrorResponse? = nil
    
    init(_ errorType: ErrorNetworkType, content data: Data? = nil) {
        self.errorType = errorType
        if let data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
            self.errorResponse = errorResponse
        }
    }
    
    init(errorType: ErrorNetworkType, errorResponse: ErrorResponse? = nil) {
        self.errorType = errorType
        self.errorResponse = errorResponse
    }
}
