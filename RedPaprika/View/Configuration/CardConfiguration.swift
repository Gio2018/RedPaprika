// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

/// Configuration for a recipe card
struct CardConfiguration: Identifiable, Equatable, Sendable {
    let id: UUID
    let name: String
    let thumbnailUrl: String?
    let photoUrl: String?
    let sourceUrl: String?
    let youtubeUrl: String?
}
