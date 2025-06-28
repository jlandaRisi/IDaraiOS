import Foundation

actor NetworkService: @preconcurrency NetworkServicing {
    var responseHandler: ResponseHandling
    var requestBuilder: RequestBuilding
    var session :URLSessionFetching
    
    init(requestBuilder: RequestBuilding,
         responseHandler: ResponseHandling = ResponseHandler(),
         session: URLSessionFetching = URLSession.shared) {
        self.requestBuilder = requestBuilder
        self.responseHandler = responseHandler
        self.session = session
    }
    
    func performRequest<T: Decodable>(
        for endpoint: Endpoint,
        decodingType: T.Type
    ) async -> ServiceResponse<T> {
        do {
            let request = try requestBuilder.buildRequest(for: endpoint)
            let (data, response) = try await session.data(for: request)
            
            switch responseHandler.handleResponse(data, response) {
            case .success(let validData):
                if T.self == Data.self, let dataResult = validData as? T {
                    return .success(dataResult)
                }
                
                let successModel = try JSONDecoder().decode(decodingType, from: validData)
                return .success(successModel)
            case .failure(let networkError):
                return .failed(networkError)
            }
        } catch {
            return .failed(ServiceResponseError(errorType: .unknown))
        }
    }
}
