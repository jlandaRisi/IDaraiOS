import CoreImage
import UIKit

public final class PersonVisionProcessor: PersonVisionProcessingProtocol {

    private let segmentation: PersonSegmentationServiceProtocol
    private let compositor = BackgroundCompositor()

    public init(segmentation: PersonSegmentationServiceProtocol = PersonSegmentationService()) {
            self.segmentation = segmentation
        }

    public func blurBackground(from image: UIImage,
                                  radius: Double = 15,   
                                  overlay color: UIColor? = nil) async throws -> UIImage {

           let mask = try await segmentation.personMask(from: image)
           let original = CIImage(image: image)!

        var blurred = original
            .clampedToExtent()
            .applyingFilter("CIGaussianBlur",
                            parameters: ["inputRadius": radius])
            .cropped(to: original.extent)

           if let tint = color {
               let overlay = CIImage(color: CIColor(color: tint))
                   .cropped(to: original.extent)
               blurred = overlay.composited(over: blurred)
           }

           return try compositor.compose(foreground: image,
                                         mask: mask,
                                         background: blurred)
       }
}
