//
//  APIService.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case serverError(Int)
    case noData
    case decodingError
    case unknown
}

protocol APIServiceProtocol {
    func fetch<T: Decodable>(from urlString: String) async throws -> T
}

final class APIService: APIServiceProtocol {
    func fetch<T: Decodable>(from urlString: String) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw APIError.invalidURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: data)
            return decoded
        } catch {
            throw APIError.decodingError
        }
    }
}
