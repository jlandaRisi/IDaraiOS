import XCTest
@testable import iOSNativeProject

final class InternetValidationStrategyTests: XCTestCase {
    private var session: URLSessionMock!
    private var sut: HTTPPingValidationStrategy!

    override func setUp() {
        super.setUp()
        session = URLSessionMock()
        sut     = HTTPPingValidationStrategy()
    }

    override func tearDown() {
        session = nil
        sut     = nil
        super.tearDown()
    }

    func testInternetAccessSuccess() async {
        // Given
        session.nextStatusCode = 204
        // When
        let result = await sut.hasInternetAccess(using: session)
        // Then
        XCTAssertTrue(result)
    }

    func testInternetAccessError() async {
        // Given
        session.shouldThrow = true
        // When
        let result = await sut.hasInternetAccess(using: session)
        // Then
        XCTAssertFalse(result)
    }

    func testInternetAccessBadStatus() async {
        // Given
        session.nextStatusCode = 503
        // When
        let result = await sut.hasInternetAccess(using: session)
        // Then
        XCTAssertFalse(result)
    }
}
