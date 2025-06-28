import Foundation
@testable import iOSNativeProject

extension MockConnectivityService {
    
    func getValidatedStatus(
        validator: InternetValidationStrategy = HTTPPingValidationStrategy(),
        session: URLSessionProtocol = URLSession.shared
    ) async -> ConnectivityStatus {
        let status = await getCurrentStatus()
        guard case .connected = status else { return status }
        let hasInternet = await validator.hasInternetAccess(using: session)
        return hasInternet ? status : .disconnected
    }
}
