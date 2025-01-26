// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext

    private let store: RecipeStore

    init(container: ModelContainer) {
        self.store = RecipeStore(modelContainer: container)
    }

    var body: some View {
        Text("Hello, world")
            .task {
                do {
                    try await store.getRecipes()
                } catch {
                    print(error)
                }
            }
    }
}

//#Preview {
//    ContentView()
//}
