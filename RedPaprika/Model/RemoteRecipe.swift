// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// A recipe fetched from the backend
struct RemoteRecipe: Decodable, Sendable {
    let cuisine: String
    let name: String
    let photoUrlLarge: String?
    let photoUrlSmall: String?
    let uuid: UUID
    let sourceUrl: String?
    let youtubeUrl: String?
}

/// Container for recipes fetched from the backend
struct RemoteRecipes: Decodable {
    let recipes: [RemoteRecipe]
}
