// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import UIKit

enum ImageError: Error {
    case invalidData
}

/// Generic image store
protocol ImageCache: Sendable {
    /// Load an image to the store from an url
    func load(from url: String, service: ImageService) async -> Bool
}

@ModelActor
final actor SwiftDataImageStore: ImageCache {
    func load(from url: String, service: ImageService) async -> Bool {
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
        // but if for some reason (e.g. the data got corrupted) it exists,
        // it will be fetched and updated with freshly validated data.
        let result = try modelContext.fetch(fetchDescriptor)
        if let cachedImage = result.first {
            cachedImage.data = data
        } else {
            let cachedImage = CachedImage(url: url, data: data)
            modelContext.insert(cachedImage)
        }
        try modelContext.save()
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
