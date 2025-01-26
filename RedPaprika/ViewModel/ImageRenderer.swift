// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// Holds the state of a `RemoteImage` instance depending on the state of the cached/loaded image.
@MainActor
final class ImageRenderer: ObservableObject {
    private let cache: ImageCache
    private let service: ImageService
    private let url: String

    @Published var state: ViewState = .idle

    init(cache: ImageCache, service: ImageService, url: String) {
        self.cache = cache
        self.service = service
        self.url = url
    }

    func storeImage() async {
        guard state != .loading else { return }
        state = .loading
        let result = await cache.store(from: url, service: service)
        state = result ? .ready : .error
    }
}
