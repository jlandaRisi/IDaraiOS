import Foundation

protocol ResponseHandling {
    var errorMapper: ErrorMapping { set get }
    
    func handleResponse(_ data: Data?, _ response: URLResponse) -> Result<Data, ServiceResponseError>
}
