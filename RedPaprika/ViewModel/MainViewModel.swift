// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// Holds the state of `MainView` depending on the results of the fetching of recipes.
@MainActor
final class MainViewModel: ObservableObject {
    private let store: any RecipeStore
    private let service: any RecipeService

    @Published var state: ViewState = .idle

    init(store: any RecipeStore, service: any RecipeService) {
        self.store = store
        self.service = service
    }

    func fetchRecipes() async {
        guard state != .loading else { return }
        state = .loading
        let result = await store.refreshRecipes(from: service)
        state = result ? .ready : .error
    }
}
