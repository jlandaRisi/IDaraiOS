import Foundation

/**
 A protocol that defines the interface for monitoring and retrieving network connectivity information.
 Implementers of this protocol provide functionality to check the current connectivity status,
 monitor changes in connectivity, and retrieve the type of connection.
 */
public protocol ConnectivityServiceProtocol {
    /**
     Retrieves the current network connectivity status.
     - Returns: The current `ConnectivityStatus` indicating whether the device is connected
       and the type of connection (WiFi, Cellular, or Other).
     */
    func getCurrentStatus() async -> ConnectivityStatus

    /**
     Starts monitoring network connectivity changes.
     - Throws: An error if monitoring fails to start.
     - Returns: The initial `ConnectivityStatus` when monitoring begins.
     */
    func startMonitoring() async throws -> ConnectivityStatus

    /**
     Stops monitoring network connectivity changes.
     This method cancels the network monitor and releases resources.
     */
    func stopMonitoring()

    /**
     Retrieves the current connection type (WiFi, Cellular, or Other).
     - Returns: The `ConnectionType` if connected, or `nil` if disconnected.
     */
    func getConnectionType() async -> ConnectionType?
}
