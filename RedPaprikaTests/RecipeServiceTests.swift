// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Testing
@testable import RedPaprika
import Foundation

struct RecipeServiceTests {

    struct MockClient: Client {
        private let fixture: String

        init(fixture: String) {
            self.fixture = fixture
        }
        func getData(from url: String) async throws -> Data {
            fixture.data(using: .utf8)!
        }
        
    }

    @Test("Given a correct json from the client, the service returns valid data")
    func testSuccess() async throws {
        // Given
        let client = MockClient(fixture: RecipeFixtures.valid)
        let service = AppRecipeService(client: client)
        // When
        let recipes = try await service.getRecipes()
        // Then
        #expect(recipes.count == 3)
    }

    @Test("Given an empty json from the client, the service returns an empty array")
    func testEmpty() async throws {
        // Given
        let client = MockClient(fixture: RecipeFixtures.empty)
        let service = AppRecipeService(client: client)
        // When
        let recipes = try await service.getRecipes()
        // Then
        #expect(recipes.isEmpty)
    }

    @Test("Given a malformed json from the client, the service throws an error")
    func testMalformed() async throws {
        // Given
        let client = MockClient(fixture: RecipeFixtures.malformed)
        let service = AppRecipeService(client: client)
        // When/then
        await #expect(throws: (any Error).self) {
            _ = try await service.getRecipes()
        }

    }
}
