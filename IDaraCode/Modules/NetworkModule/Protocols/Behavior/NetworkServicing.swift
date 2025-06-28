protocol NetworkServicing {
    var responseHandler: ResponseHandling { set get }
    var requestBuilder: RequestBuilding { set get }
    var session :URLSessionFetching { set get }
    
    func performRequest<T: Decodable>(for endpoint: Endpoint, decodingType: T.Type) async -> ServiceResponse<T>
}
