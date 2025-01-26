// Red Paprika recipe app
// Giorgio Ruscigno, 2025.

import Foundation

enum ClientError: Error, Sendable {
    case invalidURL
    case invalidResponse
    case serverError
}

/// Generic client to fetch data from a URL
protocol Client: Sendable {
    func getData(from url: String) async throws -> Data
}

/// HTTP `Client` implementation
struct HTTPClient: Client {
    func getData(from url: String) async throws -> Data {
        let session = URLSession.shared
        guard let url = URL(string: url) else {
            throw ClientError.invalidURL
        }

        let (data, response) = try await session.data(from: url)
        let httpResponse = try response.httpUrlResponse()

        // Here we could handle more cases to distinguish beteween different errors
        guard (200...299).contains(httpResponse.statusCode) else {
            throw ClientError.serverError
        }
        return data
    }
}

private extension URLResponse {
    /// Extracts the HTTPURLResponse from a URLResponse
    func httpUrlResponse() throws -> HTTPURLResponse {
        guard let response = self as? HTTPURLResponse else {
            throw ClientError.invalidResponse
        }
        return response
    }
}
