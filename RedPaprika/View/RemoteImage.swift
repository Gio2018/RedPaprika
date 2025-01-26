// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData
import SwiftUI

struct RemoteImage: View {
    let url: String

    @StateObject private var renderer: ImageRenderer

    @Query private var cachedImage: [CachedImage]
    var image: Image? {
        guard let cachedImage = cachedImage.first else {
            return nil
        }
        return cachedImage.image
    }

    init(url: String, service: ImageService, cache: ImageCache) {
        self.url = url
        _renderer = StateObject(wrappedValue: ImageRenderer(cache: cache, service: service, url: url))
        let predicate = #Predicate<CachedImage> { $0.url == url }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1
        _cachedImage = Query(fetchDescriptor, animation: .smooth)

    }

    var body: some View {
        ZStack {
            switch renderer.state {
            case .loading, .idle:
                Image("Placeholder")
                    .resizable()
                ProgressView()
            case .ready:
                if let image {
                    image
                        .resizable()
                } else {
                    Image("Placeholder")
                        .resizable()
                }
            default:
                Image("Placeholder")
                    .resizable()
            }
        }
        .onAppear {
            Task(priority: .userInitiated) {
                await renderer.storeImage()
            }
        }
    }
}

#Preview {
    let container = PreviewProvider.previewContainer
    let dependencies = PreviewDependencies()
    let imageCache = PreviewImageCache()
    let imageService = PreviewImageService()

    RemoteImage(
        url: "https://via.placeholder.com/150",
        service: imageService,
        cache: imageCache
    )
    .modelContainer(container)
}
