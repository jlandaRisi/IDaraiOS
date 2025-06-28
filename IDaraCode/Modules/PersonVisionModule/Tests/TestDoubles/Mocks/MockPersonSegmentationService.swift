import UIKit
@testable import iOSNativeProject


final class MockPersonSegmentationService: PersonSegmentationServiceProtocol {

    private let mockMask: CGImage
    private let shouldThrow: Bool

    init(mask: CGImage, shouldThrow: Bool = false) {
        self.mockMask   = mask
        self.shouldThrow = shouldThrow
    }

    func personMask(from _: UIImage) async throws -> CGImage {
        if shouldThrow { throw PersonVisionError.noPersonDetected }
        return mockMask
    }
}
