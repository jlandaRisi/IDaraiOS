import Foundation
@testable import iOSNativeProject

class MockConnectivityService: ConnectivityServiceProtocol {
    var currentStatus: ConnectivityStatus = .disconnected
    var shouldThrowError: Bool = false

    func getCurrentStatus() async -> ConnectivityStatus {
        return currentStatus
    }

    func startMonitoring() async throws -> ConnectivityStatus {
        if shouldThrowError {
            throw NSError(domain: "MockError", code: 1, userInfo: nil)
        }
        return currentStatus
    }

    func stopMonitoring() {
        // No-op for mock
    }

    func getConnectionType() async -> ConnectionType? {
        switch currentStatus {
        case .connected(let type):
            return type
        case .disconnected:
            return nil
        }
    }
}
