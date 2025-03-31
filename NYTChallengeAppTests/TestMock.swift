//
//  TestMock.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 31/03/25.
//

@testable import NYTChallengeApp

final class MockAPIServiceSuccess: APIServiceProtocol {
    func fetch<T>(from urlString: String) async throws -> T where T : Decodable {
        let mockArticle = ArticleDTO(
            id: 1,
            title: "Artículo de prueba",
            byline: "Por Tester",
            publishedDate: "2025-03-28",
            abstract: "Resumen de prueba",
            url: "https://ejemplo.com",
            media: nil
        )
        let response = ArticlesResponse(results: [mockArticle])
        return response as! T
    }
}

final class MockAPIServiceFailure: APIServiceProtocol {
    func fetch<T>(from urlString: String) async throws -> T where T : Decodable {
        throw APIError.serverError(500)
    }
}


final class MockUseCaseSuccess: GetMostPopularArticlesUseCaseProtocol {
    func execute() async throws -> [Article] {
        return [
            Article(
                id: 1,
                title: "Test",
                byline: "Tester",
                publishedDate: "2025-03-28",
                abstract: "Resumen",
                url: "https://url",
                imageUrl: nil)
        ]
    }
}

final class MockUseCaseFailure: GetMostPopularArticlesUseCaseProtocol {
    func execute() async throws -> [Article] {
        throw APIError.serverError(500)
    }
}
