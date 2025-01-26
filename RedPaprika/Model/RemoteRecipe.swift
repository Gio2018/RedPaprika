// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// SwiftData agnostic model for a recipe
/// For simplicity, we are using this type for both decoding from the backend and representing a recipe in the UI
struct RemoteRecipe: Decodable, Identifiable, Equatable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photo: Data?
    let photoUrlSmall: String?
    let thumbnail: Data?
    let uuid: UUID
    let sourceUrl: String?
    let youtubeUrl: String?

    var id: UUID { uuid }
}

/// Container for recipes fetched from the backend
struct RemoteRecipes: Decodable {
    let recipes: [RemoteRecipe]
}
