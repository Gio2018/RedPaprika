// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftData

@MainActor
class PreviewProvider {
    static let previewContainer: ModelContainer = {
            do {
                let config = ModelConfiguration(isStoredInMemoryOnly: true)
                let schema = Schema([
                    Cuisine.self,
                    Recipe.self
                ])
                let container = try ModelContainer(for: schema, configurations: config)

                let cuisine = Cuisine(name: "Italian")
                container.mainContext.insert(cuisine)

                for i in 1...5 {
                    let recipe = Recipe(name: "Recipe \(i)", remoteID: "bogusID - \(i)", cuisine: cuisine)
                    container.mainContext.insert(recipe)
                }

                return container
            } catch {
                fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
            }
        }()

    static let previewStore: RecipeStore = {
        PreviewStore()
    }()
}

struct PreviewStore: RecipeStore {
    func fetchRecipes() async throws {
        // data are already inserted, no need to do anything
    }
}
