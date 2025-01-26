// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

protocol ImageService: Sendable {
    func fetchImageData(from url: String) async throws -> Data
}

struct AppImageService: ImageService {
    private let client: Client

    init(client: Client) {
        self.client = client
    }

    func fetchImageData(from url: String) async throws -> Data {
        try await client.getData(from: url)
    }
}
