import XCTest
import CoreImage
@testable import iOSNativeProject

final class PersonVisionProcessorTests: XCTestCase {

 
    private func makeStubImages() -> (original: UIImage, mask: CGImage) {

        let size = CGSize(width: 100, height: 100)
        UIGraphicsBeginImageContext(size)

        UIColor.blue.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))

        UIColor.green.setFill()
        UIRectFill(CGRect(x: 30, y: 30, width: 40, height: 40))

        let original = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()


        let renderer = UIGraphicsImageRenderer(size: size)
        let maskUIImage = renderer.image { ctx in
            UIColor.black.setFill()
            ctx.fill(CGRect(origin: .zero, size: size))
            UIColor.white.setFill()
            ctx.fill(CGRect(x: 30, y: 30, width: 40, height: 40))
        }
        return (original, maskUIImage.cgImage!)
    }

    func testBlurBackgroundReturnsImage() async throws {
        // Given
        let (original, cgMask) = makeStubImages()
        let sut = PersonVisionProcessor(
                    segmentation: MockPersonSegmentationService(mask: cgMask))

        // When
        let result = try await sut.blurBackground(from: original)

        // Then
        XCTAssertNotNil(result, "It should return a processed image")
        XCTAssertEqual(result.size, original.size, "Maintains original size")
    }

    func testBlurBackgroundKeepsPersonAreaSharp() async throws {
        // Given
        let (original, cgMask) = makeStubImages()
        let sut = PersonVisionProcessor(
                    segmentation: MockPersonSegmentationService(mask: cgMask))

        // When
        let blurred = try await sut.blurBackground(from: original, radius: 20)

        // Then
        let centerColor = blurred.pixelColor(at: CGPoint(x: 50, y: 50))
        XCTAssertEqual(centerColor?.greenComponent ?? 0, 1, accuracy: 0.05,
                       "The person's area should be kept clear")
    }

    func testBlurBackgroundAppliesOverlayColor() async throws {
        // Given
        let (original, cgMask) = makeStubImages()
        let overlay = UIColor.black.withAlphaComponent(0.5)
        let sut = PersonVisionProcessor(
                    segmentation: MockPersonSegmentationService(mask: cgMask))

        // When
        let processed = try await sut.blurBackground(from: original,
                                                     radius: 15,
                                                     overlay: overlay)

        // Then
        let backgroundPixel = processed.pixelColor(at: CGPoint(x: 10, y: 10))
        XCTAssertTrue((backgroundPixel?.brightness ?? 1) < 0.5,
                      "The black overlay should darken the background")
    }

    func testBlurBackgroundThrowsWhenNoPerson() async {
        // Given
        let (original, cgMask) = makeStubImages()
        let sut = PersonVisionProcessor(
                    segmentation: MockPersonSegmentationService(mask: cgMask,
                                                                shouldThrow: true))

        // When / Then
        do {
             _ = try await sut.blurBackground(from: original)
              XCTFail("Expected blurBackground to throw when no person is detected")
          } catch {
              XCTAssertEqual(error as? PersonVisionError, .noPersonDetected)
          }
    }
}

private extension UIImage {
 
    func pixelColor(at point: CGPoint) -> UIColor? {
        guard let cg = cgImage,
              let data = cg.dataProvider?.data,
              let ptr  = CFDataGetBytePtr(data) else { return nil }

        let bytesPerRow = cg.bytesPerRow
        let bytesPerPixel = cg.bitsPerPixel / 8
        let x = Int(point.x), y = Int(point.y)
        let offset = y * bytesPerRow + x * bytesPerPixel

        let r = CGFloat(ptr[offset])   / 255
        let g = CGFloat(ptr[offset+1]) / 255
        let b = CGFloat(ptr[offset+2]) / 255
        let a = CGFloat(ptr[offset+3]) / 255

        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

private extension UIColor {
    var greenComponent: CGFloat {
        var g: CGFloat = 0
        getRed(nil, green: &g, blue: nil, alpha: nil)
        return g
    }
    var brightness: CGFloat {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r + g + b) / 3
    }
}
