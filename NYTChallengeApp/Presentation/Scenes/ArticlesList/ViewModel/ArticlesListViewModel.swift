//
//  ArticlesListViewModel.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

final class ArticlesListViewModel {
    // MARK: - Properties
    private let getArticlesUseCase: GetMostPopularArticlesUseCaseProtocol

    var articles: [Article] = [] {
        didSet {
            onArticlesUpdated?()
        }
    }

    var isLoading: Bool = false {
        didSet {
            onLoadingStateChanged?(isLoading)
        }
    }

    var errorMessage: String? {
        didSet {
            if let message = errorMessage {
                onError?(message)
            }
        }
    }

    // MARK: - Callbacks
    var onArticlesUpdated: (() -> Void)?
    var onLoadingStateChanged: ((Bool) -> Void)?
    var onError: ((String) -> Void)?

    // MARK: - Init
    init(getArticlesUseCase: GetMostPopularArticlesUseCaseProtocol = GetMostPopularArticlesUseCase()) {
        self.getArticlesUseCase = getArticlesUseCase
    }

    // MARK: - Methods
    func fetchArticles() async {
        isLoading = true
        errorMessage = nil

        do {
            let result = try await getArticlesUseCase.execute()
            self.articles = result
        } catch {
            self.errorMessage = "Ocurrió un error al cargar los artículos."
        }

        isLoading = false
    }
}
