// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData
import SwiftUI

/// Environment key for dependencies
extension EnvironmentValues {
    /// This dependencies implementation only exists to provide a default value for the environment.
    /// It's not meant to be used (thus is private) and the app will crash if the appropriate dependencies are not set.
    private struct DefaultDependencies: Dependencies {
        func makeImageService() -> any ImageService {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
        
        func makeImageCache(container: ModelContainer) -> any ImageCache {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
        
        func makeModelContainer() -> ModelContainer {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }

        func makeRecipeStore(container: ModelContainer) -> RecipeStore {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }

        @MainActor
        func makeMainViewModel(store: RecipeStore) -> MainViewModel {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
    }

    @Entry var dependencies: Dependencies = DefaultDependencies()
}

/// Environment key for image cache
extension EnvironmentValues {
    /// This dependencies implementation only exists to provide a default value for the environment.
    /// It's not meant to be used (thus is private) and the app will crash if the appropriate dependencies are not set.
    private struct DefaultImageCache: ImageCache {
        func getImage(from url: String) async throws -> Image {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
        
        func store(from url: String, service: any ImageService) async -> Bool {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
    }

    @Entry var imageCache: ImageCache = DefaultImageCache()
}

extension EnvironmentValues {
    /// This dependencies implementation only exists to provide a default value for the environment.
    /// It's not meant to be used (thus is private) and the app will crash if the appropriate dependencies are not set.
    private struct DefaultImageService: ImageService {
        func fetchImageData(from url: String) async throws -> Data {
            assertionFailure("Dependencies not set. Use the environment to set a proper value.")
            fatalError("Dependencies not set. Use the environment to set a proper value.")
        }
    }
    @Entry var imageService: ImageService = DefaultImageService()
}

/// Environment key for adaptive card width
extension EnvironmentValues {
    /// Store the carousel width based on the current `Geometry`
    @Entry var cardWidth: CGFloat = 300
}
