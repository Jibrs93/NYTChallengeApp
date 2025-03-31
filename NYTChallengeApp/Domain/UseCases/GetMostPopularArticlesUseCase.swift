//
//  GetMostPopularArticlesUseCase.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

protocol GetMostPopularArticlesUseCaseProtocol {
    func execute() async throws -> [Article]
}

final class GetMostPopularArticlesUseCase: GetMostPopularArticlesUseCaseProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol = APIService()) {
        self.apiService = apiService
    }

    func execute() async throws -> [Article] {
        let apiKey = "qTl6HA9lEk9bHwEMNSrdjRAceMnSqQEZ"
        let section = "viewed" // tambien puede ser "emailed" o "shared"
        let period = 7
        let url = "https://api.nytimes.com/svc/mostpopular/v2/\(section)/\(period).json?api-key=\(apiKey)"

        let response: ArticlesResponse = try await apiService.fetch(from: url)
        return response.results.map { $0.toDomain() }
    }
}
