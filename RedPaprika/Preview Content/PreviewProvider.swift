// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import SwiftUI

@MainActor
class PreviewProvider {
    static let previewContainer: ModelContainer = {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([
                Cuisine.self,
                Recipe.self,
                CachedImage.self
            ])
            let container = try ModelContainer(for: schema, configurations: config)

            let italianCuisine = Cuisine(name: "Italian")
            container.mainContext.insert(italianCuisine)

            let frenchCuisine = Cuisine(name: "French")
            container.mainContext.insert(frenchCuisine)

            let greekCuisine = Cuisine(name: "Greek")
            container.mainContext.insert(frenchCuisine)

            for i in 1...5 {
                let italianRecipe = Recipe(name: "Italian Recipe \(i)", remoteID: UUID(), cuisine: italianCuisine)
                italianRecipe.photoUrl = "https://via.placeholder.com/150"
                container.mainContext.insert(italianRecipe)

                let frenchRecipe = Recipe(name: "This is a Long French Recipe Name, and its number is: \(i)", remoteID: UUID(), cuisine: frenchCuisine)
                frenchRecipe.photoUrl = "https://via.placeholder.com/150"
                container.mainContext.insert(frenchRecipe)

                let greekRecipe = Recipe(name: "Greek Recipe \(i)", remoteID: UUID(), cuisine: greekCuisine)
                greekRecipe.photoUrl = "https://via.placeholder.com/150"
                container.mainContext.insert(greekRecipe)
            }

            let data = UIImage(named: "PreviewLarge")!.pngData()!

            let cachedImage = CachedImage(url: "https://via.placeholder.com/150", data: data)
            container.mainContext.insert(cachedImage)


            try! container.mainContext.save()

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }()
}

struct PreviewImageService: ImageService {
    func fetchImageData(from url: String) async throws -> Data {
        Data()
    }
}

struct PreviewImageCache: ImageCache {
    func store(from url: String, service: any ImageService) async -> Bool {
        true
    }
    
    func getImage(from url: String) async throws -> Image {
        Image("PreviewLarge")
    }
}

struct PreviewRecipeService: RecipeService {
    func getRecipes() async throws -> [RemoteRecipe] {
        []
    }
}


struct previewClient: Client {
    func getData(from url: String) async throws -> Data {
        Data()
    }
}

struct PreviewStore: RecipeStore {
    func refreshRecipes(from service: RecipeService) async -> Bool {
        true
    }
}

struct PreviewDependencies: Dependencies {
    func makeModelContainer() -> ModelContainer {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let schema = Schema([
            Cuisine.self,
            Recipe.self,
            CachedImage.self
        ])
        return try! ModelContainer(for: schema, configurations: config)
    }
    
    func makeRecipeStore(container: ModelContainer) -> any RecipeStore {
        PreviewStore()
    }
    
    func makeImageCache(container: ModelContainer) -> any ImageCache {
        PreviewImageCache()
    }
    
    func makeImageService() -> any ImageService {
        PreviewImageService()
    }
    
    func makeMainViewModel(store: any RecipeStore) -> MainViewModel {
        MainViewModel(store: PreviewStore(), service: PreviewRecipeService())
    }
}
