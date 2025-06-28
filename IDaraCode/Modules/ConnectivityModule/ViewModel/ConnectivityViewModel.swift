import Foundation

@MainActor
class ConnectivityViewModel: ObservableObject {
    @Published var connectivityStatus: ConnectivityStatus = .disconnected

    private let service: ConnectivityServiceProtocol

    init(service: ConnectivityServiceProtocol) async {
        self.service = service
        self.connectivityStatus = await service.getCurrentStatus()
    }

    func startMonitoring() async {
        do {
            let status = try await service.startMonitoring()
            DispatchQueue.main.async {
                self.connectivityStatus = status
            }
        } catch {
            print("Failed to start monitoring: \(error)")
        }
    }

    func stopMonitoring() {
        service.stopMonitoring()
    }
}
