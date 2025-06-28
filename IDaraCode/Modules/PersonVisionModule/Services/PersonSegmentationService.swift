import Vision
import CoreImage
import UIKit

public final class PersonSegmentationService: PersonSegmentationServiceProtocol {

    private let ciContext = CIContext(options: nil)

    public init() {}

    public func personMask(from image: UIImage) async throws -> CGImage {
        guard let ciImage = CIImage(image: image) else {
            throw PersonVisionError.noPersonDetected
        }

        let request = VNGeneratePersonSegmentationRequest()
        request.qualityLevel      = .accurate
        request.outputPixelFormat = kCVPixelFormatType_OneComponent8

        try VNImageRequestHandler(ciImage: ciImage).perform([request])

        guard let observation = request.results?.first else {
            throw PersonVisionError.noPersonDetected
        }

        let pixelBuffer: CVPixelBuffer = observation.pixelBuffer
        let rect = CGRect(x: 0, y: 0,
                          width:  CVPixelBufferGetWidth(pixelBuffer),
                          height: CVPixelBufferGetHeight(pixelBuffer))

        guard let cgMask = ciContext.createCGImage(CIImage(cvPixelBuffer: pixelBuffer),
                                                   from: rect) else {
            throw PersonVisionError.noPersonDetected
        }
        return cgMask
    }
}
