//
//  GetMostPopularArticlesUseCaseTests.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 31/03/25.
//

import XCTest
@testable import NYTChallengeApp

// MARK: - Tests
final class GetMostPopularArticlesUseCaseTests: XCTestCase {

    var useCase: GetMostPopularArticlesUseCase!

    override func setUp() {
        super.setUp()
        useCase = nil // se asigna en cada test según el tipo de mock
    }

    override func tearDown() {
        useCase = nil
        super.tearDown()
    }

    func testExecuteReturnsArticles() async throws {
        useCase = GetMostPopularArticlesUseCase(apiService: MockAPIServiceSuccess())

        let articles = try await useCase.execute()

        // Then
        XCTAssertEqual(articles.count, 1)
        XCTAssertEqual(articles.first?.title, "Test News")
    }

    func testExecuteThrowsError() async {
        useCase = GetMostPopularArticlesUseCase(apiService: MockAPIServiceFailure())

        do {
            _ = try await useCase.execute()
            XCTFail("Wait to have Error, but Not")
        } catch {
            XCTAssertTrue(error is APIError)
        }
    }
}
