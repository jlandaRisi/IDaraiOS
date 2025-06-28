import Foundation
import Network

/**
 A service that monitors network connectivity using Apple's Network framework.
 This service conforms to the `ConnectivityServiceProtocol` and provides methods
 to retrieve the current connectivity status and monitor changes in network connectivity.
 */
public class NetworkReachabilityService: ConnectivityServiceProtocol {
    /// A monitor instance from the Network framework to observe network changes.
    private var monitor: NWPathMonitor?

    /// A dispatch queue for handling network monitoring events.
    private let queue = DispatchQueue(label: "NetworkReachabilityMonitor")

    /**
     Retrieves the current network connectivity status.
     - Returns: The current `ConnectivityStatus` indicating whether the device is connected
       and the type of connection (WiFi, Cellular, or Other).
     */
    public func getCurrentStatus() async -> ConnectivityStatus {
        return await withCheckedContinuation { continuation in
            let monitor = NWPathMonitor()
            let queue = DispatchQueue(label: "NetworkReachabilityMonitor.getCurrentStatus")
            monitor.pathUpdateHandler = { path in
                let status: ConnectivityStatus
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        status = .connected(.wifi)
                    } else if path.usesInterfaceType(.cellular) {
                        status = .connected(.cellular)
                    } else {
                        status = .connected(.other)
                    }
                } else {
                    status = .disconnected
                }
                continuation.resume(returning: status)
                monitor.cancel()
            }
            monitor.start(queue: queue)
        }
    }

    /**
     Starts monitoring network connectivity changes.
     - Throws: An error if monitoring fails to start.
     - Returns: The initial `ConnectivityStatus` when monitoring begins.
     */
    public func startMonitoring() async throws -> ConnectivityStatus {
        monitor = NWPathMonitor()
        return try await withCheckedThrowingContinuation { continuation in
            monitor?.pathUpdateHandler = { path in
                let status: ConnectivityStatus
                if path.status == .satisfied {
                    if path.usesInterfaceType(.wifi) {
                        status = .connected(.wifi)
                    } else if path.usesInterfaceType(.cellular) {
                        status = .connected(.cellular)
                    } else {
                        status = .connected(.other)
                    }
                } else {
                    status = .disconnected
                }
                continuation.resume(returning: status)
            }
            monitor?.start(queue: queue)
        }
    }

    /**
     Stops monitoring network connectivity changes.
     This method cancels the network monitor and releases resources.
     */
    public func stopMonitoring() {
        monitor?.cancel()
        monitor = nil
    }

    /**
     Retrieves the current connection type (WiFi, Cellular, or Other).
     - Returns: The `ConnectivityStatus.ConnectionType` if connected, or `nil` if disconnected.
     */
    public func getConnectionType() async -> ConnectionType? {
        let status = await getCurrentStatus()
        switch status {
        case .connected(let type):
            return type
        case .disconnected:
            return nil
        }
    }
}
