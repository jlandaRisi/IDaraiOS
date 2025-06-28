import UIKit

public protocol PersonVisionProcessingProtocol {
    func blurBackground(from image: UIImage,
                           radius: Double,
                           overlay color: UIColor?) async throws -> UIImage
}
