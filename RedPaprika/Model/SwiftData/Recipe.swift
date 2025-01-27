// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData
import SwiftUI

@Model final class Recipe {
    var name: String
    var remoteID: UUID
    var thumbnailUrl: String?
    var photoUrl: String?
    var sourceUrl: String?
    var youtubeUrl: String?
    // in theory, this could/should be non optoional, but in practice, it needs to..
    // https://forums.developer.apple.com/forums/thread/772885
    var cuisine: Cuisine?

    init(name: String, remoteID: UUID, cuisine: Cuisine) {
        self.name = name
        self.remoteID = remoteID
        self.cuisine = cuisine
    }
}
