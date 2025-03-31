//
//  ArticlesListViewModelTests.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 31/03/25.
//

import XCTest
@testable import NYTChallengeApp

final class ArticlesListViewModelTests: XCTestCase {

    var viewModel: ArticlesListViewModel!

    override func setUp() {
        super.setUp()
        viewModel = nil
    }

    override func tearDown() {
        viewModel = nil
        super.tearDown()
    }

    func testFetchArticlesSuccess() async {
        viewModel = ArticlesListViewModel(getArticlesUseCase: MockUseCaseSuccess())

        let expectation = expectation(description: "onArticlesUpdated called")
        viewModel.onArticlesUpdated = {
            expectation.fulfill()
        }

        await viewModel.fetchArticles()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(viewModel.articles.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }

    func testFetchArticlesFailure() async {
        viewModel = ArticlesListViewModel(getArticlesUseCase: MockUseCaseFailure())

        let expectation = expectation(description: "onError called")
        viewModel.onError = { message in
            XCTAssertEqual(message, "Error when error Charge.")
            expectation.fulfill()
        }

        await viewModel.fetchArticles()

        wait(for: [expectation], timeout: 1.0)
        XCTAssertTrue(viewModel.articles.isEmpty)
    }
}
