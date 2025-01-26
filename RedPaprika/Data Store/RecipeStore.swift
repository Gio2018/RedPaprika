// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData

// TODO: REFACTOR: use @ModelActor strictly for SwiftData and wrap into an observable object (viewmodel?)

/// Generic recipe store
protocol RecipeStore: Sendable {
    /// Fetch recipes and makes them available to the store
    /// - Returns: true if the fetch succeeds
    func fetchRecipes(service: RecipeService) async -> Bool
}

/// SwiftData backed implementation of `RecipeStore`
@ModelActor
final actor SwiftDataRecipeStore: RecipeStore {
    func fetchRecipes(service: RecipeService) async -> Bool {
        do {
            let remoteRecipes = try await service.getRecipes()
            try await updateRecipes(from: remoteRecipes)
            return true
        } catch {
            print(error)
            return false
        }
    }

    private func updateRecipes(from remoteRecipes: [RemoteRecipe]) async throws {
        let recipesByCuisine = remoteRecipes.reduce(into: [String: [RemoteRecipe]]()) {
            if let recipes = $0[$1.cuisine] {
                $0[$1.cuisine] = recipes + [$1]
            } else {
                $0[$1.cuisine] = [$1]
            }
        }

        try recipesByCuisine.forEach { cuisine in
            let storedCuisine = try fetchOrCreateCuisine(cuisine.key)
            cuisine.value.forEach {
                let recipe = fetchOrCreateRecipe(remoteID: $0.uuid, name: $0.name, cuisine: storedCuisine)
                // these checks are a little tedious but minimize writes to Core Data
                // an improvement would be to implement a more general way to do it
                if recipe.thumbnailUrl != $0.photoUrlSmall {
                    recipe.thumbnailUrl = $0.photoUrlSmall
                }
                if recipe.photoUrl != $0.photoUrlLarge {
                    recipe.photoUrl = $0.photoUrlLarge
                }
                if recipe.sourceUrl != $0.sourceUrl {
                    recipe.sourceUrl = $0.sourceUrl
                }
                if recipe.youtubeUrl != $0.youtubeUrl {
                    recipe.youtubeUrl = $0.youtubeUrl
                }
            }
        }
        // TODO: add removal of orphaned recipes and cuisines
        guard modelContext.hasChanges else { return }
        try modelContext.save()
    }

    private func fetchOrCreateCuisine(_ name: String) throws -> Cuisine {
        let predicate = #Predicate<Cuisine> { $0.name == name }
        var fetchDescriptor = FetchDescriptor(predicate: predicate)
        fetchDescriptor.fetchLimit = 1

        let result = try modelContext.fetch(fetchDescriptor)
        if let cuisine = result.first {
            return cuisine
        } else {
            let cuisine = Cuisine(name: name)
            modelContext.insert(cuisine)
            return cuisine
        }
    }

    private func fetchOrCreateRecipe(remoteID: UUID, name: String, cuisine: Cuisine) -> Recipe {
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
