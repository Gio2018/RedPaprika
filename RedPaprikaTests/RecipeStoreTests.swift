// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Testing
@testable import RedPaprika
import SwiftData

struct RecipeStoreTests {
    let modelContainer = InMemoryModelContainer.makeContainer()

    struct MockService: RecipeService {
        private let recipes: [RedPaprika.RemoteRecipe]
        private let shouldThrow: Bool

        enum MockServiceError: Error {
            case testError
        }

        init(recipes: [RedPaprika.RemoteRecipe] = [], shouldThrow: Bool = false) {
            self.recipes = recipes
            self.shouldThrow = shouldThrow
        }

        func getRecipes() async throws -> [RedPaprika.RemoteRecipe] {
            guard !shouldThrow else {
                throw MockServiceError.testError
            }
            return recipes
        }
    }

    @Test("Given a valid array of [RemoteRecipe], the store inserts the corresponding recipes in SwiftData")
    @MainActor
    func testSuccess() async throws {
        // Given
        let service = MockService(recipes: RecipeFixtures.validRemoteRecipes)
        let store = SwiftDataRecipeStore(modelContainer: modelContainer)
        // When
        let result = await store.refreshRecipes(from: service)
        // Then
        #expect(result)
        let fetchDescriptor = FetchDescriptor<Recipe>()
        let recipes = try modelContainer.mainContext.fetch(fetchDescriptor)
        #expect(recipes.count == 3)
    }

    @Test("Given an empty array of [RemoteRecipe], the store does not insert any recipe in SwiftData")
    @MainActor
    func testEmpty() async throws {
        // Given
        let service = MockService()
        let store = SwiftDataRecipeStore(modelContainer: modelContainer)
        // When
        let result = await store.refreshRecipes(from: service)
        // Then
        #expect(result)
        let fetchDescriptor = FetchDescriptor<Recipe>()
        let recipes = try modelContainer.mainContext.fetch(fetchDescriptor)
        #expect(recipes.isEmpty)
    }

    @Test("Given a service that throws, the refresh method returns false")
    @MainActor
    func testMalformed() async throws {
        // Given
        let service = MockService(shouldThrow: true)
        let store = SwiftDataRecipeStore(modelContainer: modelContainer)
        // When
        let result = await store.refreshRecipes(from: service)
        // Then
        #expect(!result)
    }
}
