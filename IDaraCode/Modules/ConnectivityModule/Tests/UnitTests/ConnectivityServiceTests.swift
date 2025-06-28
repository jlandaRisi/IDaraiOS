import XCTest
@testable import iOSNativeProject

final class ConnectivityServiceTests: XCTestCase {
    private var sut: MockConnectivityService!
    
    override func setUp() {
        super.setUp()
        sut = MockConnectivityService()
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testGetCurrentStatus() async {
        // Given
        sut.currentStatus = .connected(.wifi)
        
        // When
        var status = await sut.getCurrentStatus()
        
        // Then
        switch status {
        case .connected(let type): XCTAssertEqual(type, .wifi)
        case .disconnected:        XCTFail("Expected Wi-Fi connected status")
        }
        
        sut.currentStatus = .connected(.cellular)
        status = await sut.getCurrentStatus()
        
        switch status {
        case .connected(let type): XCTAssertEqual(type, .cellular)
        case .disconnected:        XCTFail("Expected Cellular connected status")
        }
        
        sut.currentStatus = .disconnected
        status = await sut.getCurrentStatus()
        
        switch status {
        case .connected:
            XCTFail("Expected disconnected status")
        case .disconnected:
            XCTAssertTrue(true)
        }
    }
    
    func testStartAndStopMonitoring() async throws {
        // Given
        sut.currentStatus = .connected(.cellular)
        
        // When
        var status = try await sut.startMonitoring()
        
        // Then
        switch status {
        case .connected(let type): XCTAssertEqual(type, .cellular)
        case .disconnected:        XCTFail("Expected connected status")
        }
        
        sut.currentStatus = .disconnected
        status = try await sut.startMonitoring()
        switch status {
        case .connected:
            XCTFail("Expected disconnected status after network loss")
        case .disconnected:
            XCTAssertTrue(true)
        }
        
        sut.stopMonitoring()
        sut.currentStatus = .connected(.wifi)
        
        XCTAssertNoThrow( sut.stopMonitoring(), "stopMonitoring should be idempotent" )
        
    }
    
    func testGetConnectionTypeWifi() async {
        // Given
        sut.currentStatus = .connected(.wifi)
        
        // When
        let connectionType = await sut.getConnectionType()
        
        // Then
        XCTAssertEqual(connectionType, .wifi)
    }

    func testGetConnectionTypeCelluar() async {
        // Given
        sut.currentStatus = .connected(.cellular)
        
        // When
        let connectionType = await sut.getConnectionType()
        
        // Then
        XCTAssertEqual(connectionType, .cellular)
    }

    func testGetConnectionTypeWhenDisconnected() async {
        // Given
        sut.currentStatus = .disconnected
        
        // When
        let connectionType = await sut.getConnectionType()
        
        // Then
        XCTAssertNil(connectionType)
    }
}
