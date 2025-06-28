import XCTest
@testable import iOSNativeProject

final class ValidatedConnectivityTests: XCTestCase {
    private var reachability: MockConnectivityService!
    private var session: URLSessionMock!
    private var validator: HTTPPingValidationStrategy!

    override func setUp() {
        super.setUp()
        reachability = MockConnectivityService()
        session      = URLSessionMock()
        validator    = HTTPPingValidationStrategy()
    }

    override func tearDown() {
        reachability = nil
        session      = nil
        validator    = nil
        super.tearDown()
    }

    func testValidatedWifi() async {
        // Given
        reachability.currentStatus = .connected(.wifi)
        session.nextStatusCode     = 204
        // When
        let status = await reachability.getValidatedStatus(
            validator: validator,
            session: session
        )
        // Then
        switch status {
        case .connected(let connectionType):
            XCTAssertEqual(connectionType, .wifi)
        case .disconnected:
            XCTFail("Expected Wi-Fi connected status")
        }
    }

    func testValidatedCellularNoData() async {
        // Given
        reachability.currentStatus = .connected(.cellular)
        session.shouldThrow        = true
        // When
        let status = await reachability.getValidatedStatus(
            validator: validator,
            session: session
        )
        // Then
        switch status {
        case .connected:
            XCTFail("Expected disconnected status when no data balance")
        case .disconnected:
            XCTAssertTrue(true)
        }
    }

    func testValidatedAlreadyDisconnected() async {
        // Given
        reachability.currentStatus = .disconnected
        session.shouldThrow = true
        // When
        let status = await reachability.getValidatedStatus(
            validator: validator,
            session: session
        )
        // Then
        switch status {
        case .disconnected:
            XCTAssertTrue(true)
        case .connected:
            XCTFail("Expected disconnected status")
        }
    }

}
