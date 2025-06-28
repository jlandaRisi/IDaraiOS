import UIKit

public protocol PersonSegmentationServiceProtocol {
    func personMask(from image: UIImage) async throws -> CGImage
}
