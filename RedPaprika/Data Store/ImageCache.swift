// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import SwiftUI

enum ImageError: Error {
    case invalidData
}

/// Generic image cache
protocol ImageCache: Sendable {
    /// Stores a remote image in the cache
    func store(from url: String, service: ImageService) async -> Bool
    /// Retrieves an image from the cache, if/when needed
    func getImage(from url: String) async throws -> Image
}

/// SwiftData backed implementation of `ImageCache`
@ModelActor
final actor SwiftDataImageCache: ImageCache {
    func store(from url: String, service: ImageService) async -> Bool {
        guard !imageExists(from: url) else {
            return true
        }
        do {
            let remoteImageData = try await service.fetchImageData(from: url)
            try remoteImageData.validateImage()
            try updateImage(url: url, data: remoteImageData)
            return true
        } catch {
            print(error)
            return false
        }
    }

    private func updateImage(url: String, data: Data) throws {
        let predicate = #Predicate<CachedImage> { $0.url == url }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        // if we are loading an image, this should not exist in the database
        // unless there is a corrupted image in the DB with that same url
        // (in which case, the imageExists above would fail).
        // If that's the (unlikely) case it will be fetched
        // and updated with freshly validated data.
        let result = try modelContext.fetch(fetchDescriptor)
        if let cachedImage = result.first {
            cachedImage.data = data
        } else {
            let cachedImage = CachedImage(url: url, data: data)
            modelContext.insert(cachedImage)
        }
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }

    private func imageExists(from url: String) -> Bool {
        let predicate = #Predicate<CachedImage> { $0.url == url }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        var exists = false
        do {
            let result = try modelContext.fetch(fetchDescriptor)
            if let cachedImage = result.first {
                try cachedImage.data.validateImage()
                exists = true
            }
        } catch {
            exists = false
        }
        return exists
    }

    func getImage(from url: String) async throws -> Image {
        // This method is not used in this implementation, since
        // retrieving the image relies on @Query directly in the view
        Image("Placeholder")
    }
}

private extension Data {
    /// This  creates a little overhead, but the trade off is to store valid image data only.
    func validateImage() throws {
        guard UIImage(data: self) != nil else {
            throw ImageError.invalidData
        }
    }
}
