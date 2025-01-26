// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import SwiftUI

protocol RecipeStore {
    func fetchRecipes() async throws
}

/// This implementation is used solely for a default value in the environment
struct DefaultRecipeStore: RecipeStore {
    func fetchRecipes() async throws {
        fatalError("this implementation should not be used")
    }
}

extension EnvironmentValues {
    @Entry var recipeStore: any RecipeStore = DefaultRecipeStore()
}

/// Actor for exclusive write operations on data
@ModelActor
public final actor SwiftDataRecipeStore: RecipeStore {
    private let service: RecipeService = RecipeService()

    func fetchRecipes() async throws {
        let remoteRecipes = try await service.getRecipes()
        try await updateRecipes(from: remoteRecipes)
    }

    private func updateRecipes(from remoteRecipes: [RemoteRecipe]) async throws {
        let recipesByCuisine = remoteRecipes.reduce(into: [String: [RemoteRecipe]]()) {
            if let recipes = $0[$1.cuisine] {
                $0[$1.cuisine] = recipes + [$1]
            } else {
                $0[$1.cuisine] = [$1]
            }
        }

        recipesByCuisine.forEach { cuisine in
            let storedCuisine = fetchOrCreateCuisine(cuisine.key)
            cuisine.value.forEach {
                let recipe = fetchOrCreateRecipe(remoteID: $0.uuid.uuidString, name: $0.name, cuisine: storedCuisine)
                if recipe.thumbnailUrl != $0.photoUrlSmall {
                    recipe.thumbnailUrl = $0.photoUrlSmall
                }
                recipe.thumbnailUrl = $0.photoUrlSmall
                recipe.photoUrl = $0.photoUrlLarge
                recipe.sourceUrl = $0.sourceUrl
                recipe.youtubeUrl = $0.youtubeUrl
            }
        }
        try modelContext.save()
    }

    private func fetchOrCreateCuisine(_ name: String) -> Cuisine {
        let predicate = #Predicate<Cuisine> { $0.name == name }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        let result = (try? modelContext.fetch(fetchDescriptor)) ?? []
        if let cuisine = result.first {
            return cuisine
        } else {
            let cuisine = Cuisine(name: name)
            modelContext.insert(cuisine)
            return cuisine
        }
    }

    private func fetchOrCreateRecipe(remoteID: String, name: String, cuisine: Cuisine) -> Recipe {
        let predicate = #Predicate<Recipe> { $0.remoteID == remoteID }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        let result = (try? modelContext.fetch(fetchDescriptor)) ?? []
        if let recipe = result.first {
            return recipe
        } else {
            let recipe = Recipe(name: name, remoteID: remoteID, cuisine: cuisine)
            modelContext.insert(recipe)
            return recipe
        }
    }
}

