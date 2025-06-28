import Foundation

struct Endpoint: EndpointRepresentable {
    let url: URL?
    let path: String?
    let method: HTTPMethod
    let body: Data?
    let token: String?
    let queryParams: [String: String]?

    init(url: URL? = nil,
         path: String? = nil,
         method: HTTPMethod,
         body: Data? = nil,
         token: String? = nil,
         queryParams: [String: String]? = nil) {
        
        self.url = url
        self.path = path
        self.method = method
        self.body = body
        self.token = token
        self.queryParams = queryParams
    }
}
