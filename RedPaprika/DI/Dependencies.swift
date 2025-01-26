// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData

protocol Dependencies: Sendable {
    func makeModelContainer() -> ModelContainer
    func makeRecipeStore(container: ModelContainer) -> RecipeStore
    func makeImageCache(container: ModelContainer) -> ImageCache
    func makeImageService() -> ImageService
    @MainActor
    func makeMainViewModel(store: RecipeStore) -> MainViewModel
}

struct AppDependencies: Dependencies {
    /// Instantiate the shared model container for the app
    /// - Returns: the newly created container
    func makeModelContainer() -> ModelContainer {
        let schema = Schema([
            Cuisine.self,
            Recipe.self,
            CachedImage.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    /// Instantiate the recipe store
    /// - Parameter service: the remote service to fetch recipes from
    /// - Parameter container: model container
    /// - Returns: the newly created recipe store
    func makeRecipeStore(container: ModelContainer) -> RecipeStore {
        SwiftDataRecipeStore(modelContainer: container)
    }
    
    /// Instantiate the image cache
    /// - Parameter container: model container
    /// - Returns: the newly created image cache
    func makeImageCache(container: ModelContainer) -> ImageCache {
        SwiftDataImageCache(modelContainer: container)
    }

    func makeImageService() -> ImageService {
        AppImageService(client: makeClient())
    }

    @MainActor
    func makeMainViewModel(store: RecipeStore) -> MainViewModel {
        MainViewModel(store: store, service: makeRecipeService())
    }

    private func makeRecipeService() -> RecipeService {
        AppRecipeService(client: makeClient())
    }

    private func makeClient() -> Client {
        HTTPClient()
    }
}
