import CoreImage
import UIKit


struct BackgroundCompositor {

    private let context = CIContext(options: nil)

    func compose(foreground uiImage: UIImage,
                 mask cgMask: CGImage,
                 background: CIImage) throws -> UIImage {

        guard let source = CIImage(image: uiImage) else {
            throw PersonVisionError.compositionFailed
        }

        let resizedMask = CIImage(cgImage: cgMask).resized(to: source.extent.size)

        guard let filter = CIFilter(name: "CIBlendWithMask") else {
            throw PersonVisionError.compositionFailed
        }
        filter.setValue(source,      forKey: kCIInputImageKey)
        filter.setValue(background,  forKey: kCIInputBackgroundImageKey)
        filter.setValue(resizedMask, forKey: kCIInputMaskImageKey)

        guard
            let output   = filter.outputImage,
            let cgResult = context.createCGImage(output, from: output.extent)
        else {
            throw PersonVisionError.compositionFailed
        }

        return UIImage(cgImage: cgResult,
                       scale: uiImage.scale,
                       orientation: uiImage.imageOrientation)
    }
}
