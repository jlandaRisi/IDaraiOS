# PersonVisionModule

`PersonVisionModule` is an on‑device image‑processing engine that **keeps the person in focus and blurs everything else**. It relies only on Apple frameworks (Vision + Core Image), is fully self‑contained.

---

## Features

- Person segmentation via 
- Gaussian blur applied to the background with an optional colour overlay.
- Original resolution and orientation are preserved.
- SOLID‑compliant, protocol‑driven; no UIKit / SwiftUI coupling.

---

## Architecture (MVVM‑flavoured Clean)

The module follows the MVVM architecture and adheres to SOLID principles and Clean Code practices.

---

## Components

**Protocols**

`PersonSegmentationServiceProtocol` – Segmentation contract.

`PersonVisionProcessingProtocol` – Public protocol exposing the single high‑level operation.

**Services**

`PersonSegmentationService` – Vision‑based mask generator.

`BackgroundCompositor` – Core Image blend & blur composer.

`PersonVisionProcessor` – Façade that clients call.

**Extensions**

`CIImage+Resize, UIImage+Transparency` – Internal helpers.      

### Public API 

```swift
public func blurBackground(from image: UIImage,
                           radius: Double = 15,
                           overlay color: UIColor? = nil) async throws -> UIImage
```

---

## Usage

1. **Instantiate the processor**
   ```swift
   let processor = PersonVisionProcessor()              
   ```
2. **Process any UIImage**
   ```swift
   Task {
       let result = try await processor.blurBackground(from: originalImage,
                                                       radius: 20,
                                                       overlay: UIColor.black.withAlphaComponent(0.4))
       imageView.image = result                         // show, save or share
   }
   ```
  
---

## Unit Tests

- Located in `Tests/UnitTests/PersonVisionProcessorTests.swift`.
- Use a **mock segmentation service** to avoid Vision dependency.
- Cover happy path, overlay tint, size preservation and error propagation.


