// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI
import SwiftData

@main
struct RedPaprikaApp: App {
    private let modelContainer: ModelContainer
    private let recipeStore: RecipeStore
    private let imageCache: ImageCache
    private let dependencies: Dependencies

    init() {
        dependencies = AppDependencies()
        modelContainer = dependencies.makeModelContainer()
        imageCache = dependencies.makeImageCache(container: modelContainer)
        recipeStore = dependencies.makeRecipeStore(container: modelContainer)
    }

    var body: some Scene {
        WindowGroup {
            MainView(dependencies.makeMainViewModel(store: recipeStore))
        }
        .modelContainer(modelContainer)
        .environment(\.dependencies, dependencies)
        .environment(\.imageCache, imageCache)
    }
}
