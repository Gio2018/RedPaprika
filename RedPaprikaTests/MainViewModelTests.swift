// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Testing
@testable import RedPaprika
import SwiftData

struct MainViewModelTests {
    struct MockRecipeService: RecipeService {
        func getRecipes() async throws -> [RedPaprika.RemoteRecipe] {
            []
        }
    }

    struct MockRecipeStore: RecipeStore {
        private let result: Bool

        init(result: Bool) {
            self.result = result
        }
        
        func refreshRecipes(from service: RecipeService) async -> Bool {
            result
        }
    }

    @Test("Given a successful refresh, the state is set to ready")
    func testSuccess() async {
        // Given
        let store = MockRecipeStore(result: true)
        let service = MockRecipeService()
        let viewModel = await MainViewModel(store: store, service: service)
        // When
        await viewModel.fetchRecipes()
        // Then
        await #expect(viewModel.state == .ready)
    }

    @Test("Given a failed refresh, the state is set to error")
    func testFailure() async {
        // Given
        let store = MockRecipeStore(result: false)
        let service = MockRecipeService()
        let viewModel = await MainViewModel(store: store, service: service)
        // When
        await viewModel.fetchRecipes()
        // Then
        await #expect(viewModel.state == .error)
    }
}
