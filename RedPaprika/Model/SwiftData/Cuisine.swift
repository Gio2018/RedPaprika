// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation
import SwiftData

@Model final class Cuisine {
    var name: String
    // delete a recipe entirely if it's removed from the cuisine
    @Relationship(deleteRule: .cascade, inverse: \Recipe.cuisine)
    var recipes: [Recipe]

    init(name: String, recipes: [Recipe] = []) {
        self.name = name
        self.recipes = recipes
    }
}
