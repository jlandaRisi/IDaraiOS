import Foundation

struct RequestBuilder: RequestBuilding {
    
    private var headerStrategies: [HeaderDecorator]
    private let environment: APIEnvironmentProviding
    
    public init(
        environment: APIEnvironmentProviding,
        headerStrategies: [HeaderDecorator] = []
    ) {
        self.environment = environment
        self.headerStrategies = headerStrategies
        self.headerStrategies.append(JSONHeaderDecorator())
    }
    
    func buildRequest(for endpoint: Endpoint) throws -> URLRequest {
        guard let base = URL(string: environment.baseURL) else {
            throw ServiceResponseError(errorType: .invalidURL, errorResponse: nil)
        }
        
        var urlComponents: URLComponents?
        if let path = endpoint.path {
            urlComponents = URLComponents(
                url: URL(string: path, relativeTo: base)!,
                resolvingAgainstBaseURL: true)
        } else if let url = endpoint.url {
            urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        } else {
            throw ServiceResponseError(errorType: .invalidURL, errorResponse: nil)
        }
        
        if let queryParams = endpoint.queryParams {
            urlComponents?.queryItems =
            queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        guard let finalURL = urlComponents?.url else {
            throw ServiceResponseError(errorType: .invalidURL, errorResponse: nil)
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = endpoint.method.rawValue
        request.httpBody = endpoint.body
        
        var combinedHeaders: [String: String] = [:]
        headerStrategies.forEach { strategy in
            combinedHeaders.merge(strategy.decorateHeaders()) { _, new in new }
        }
        
        request.allHTTPHeaderFields = combinedHeaders
        return request
    }
    
    mutating func addHeaderStrategy(_ strategy: HeaderDecorator) {
        headerStrategies.append(strategy)
    }
}
