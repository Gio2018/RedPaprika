// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Testing
@testable import RedPaprika
import SwiftData
import UIKit

struct ImageCacheTests {
    let modelContainer = InMemoryModelContainer.makeContainer()

    struct MockService: ImageService {
        enum MockServiceError: Error {
            case testError
        }

        private let imageData = UIImage(named: "PreviewLarge")!.pngData()!

        private let shouldThrow: Bool

        init(shouldThrow: Bool) {
            self.shouldThrow = shouldThrow
        }

        func fetchImageData(from url: String) async throws -> Data {
            guard !shouldThrow else {
                throw MockServiceError.testError
            }
            return imageData
        }
    }

    @Test("Given a valid image, the cache stores it")
    @MainActor
    func testSuccessfulCacheStore() async throws {
        // Given
        let service = MockService(shouldThrow: false)
        let cache = SwiftDataImageCache(modelContainer: modelContainer)
        // When
        let result = await cache.store(from: "https://example.com/image.png", service: service)
        // Then
        #expect(result)
        let fetchDescriptor = FetchDescriptor<CachedImage>()
        let images = try modelContainer.mainContext.fetch(fetchDescriptor)
        #expect(images.count == 1)
        #expect(images[0].data == UIImage(named: "PreviewLarge")!.pngData()!)
    }

    @Test("Given an error thrown by the service, the cache does not store any image")
    @MainActor
    func testInvalidImage() async throws {
        // Given
        let service = MockService(shouldThrow: true)
        let cache = SwiftDataImageCache(modelContainer: modelContainer)
        // When
        let result = await cache.store(from: "https://example.com/image.png", service: service)
        // Then
        #expect(!result)
        let fetchDescriptor = FetchDescriptor<CachedImage>()
        let images = try modelContainer.mainContext.fetch(fetchDescriptor)
        #expect(images.count == 0)
    }
}
