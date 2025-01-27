// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

@testable import RedPaprika
import SwiftData

struct InMemoryModelContainer {
    static func makeContainer() -> ModelContainer {
        do {
            let config = ModelConfiguration(isStoredInMemoryOnly: true)
            let schema = Schema([
                Cuisine.self,
                Recipe.self,
                CachedImage.self
            ])
            let container = try ModelContainer(for: schema, configurations: config)

            return container
        } catch {
            fatalError("Failed to create model container for previewing: \(error.localizedDescription)")
        }
    }
}
