// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

enum ApiError: Error {
    case invalidResponse
    case malformedData
    case emptyData
    case requestError
}

protocol RecipeService: Sendable {
    func getRecipes() async throws -> [RemoteRecipe]
}

/// Remote service to fetch recipes from the server
struct AppRecipeService: RecipeService {
    private static let recipesEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"
    private static let malformedRecipesEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-malformed.json"
    private static let emptyRecipesEndpoint = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes-empty.json"

    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func getRecipes() async throws -> [RemoteRecipe] {
        let data = try await client.getData(from: Self.recipesEndpoint)

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let recipes = try decoder.decode(RemoteRecipes.self, from: data).recipes

        return recipes
    }
}
