//
//  ArticlesListViewController.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import UIKit

final class ArticlesListViewController: UIViewController {
    // MARK: - UI Components
    private let headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Artículos populares esta semana"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Buscar artículo..."
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        return searchBar
    }()

    private let tableView = UITableView()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    // MARK: - Properties
    private let viewModel = ArticlesListViewModel()
    private var filteredArticles: [Article] = []
    private var isSearching = false

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "NYTChallengeApp"
        view.backgroundColor = .systemBackground
        
        let backItem = UIBarButtonItem()
        backItem.title = "Noticias"
        navigationItem.backBarButtonItem = backItem

        setupHeader()
        setupSearchBar()
        setupTableView()
        setupActivityIndicator()
        bindViewModel()
        fetchArticles()
    }

    // MARK: - Setup UI
    private func setupHeader() {
        view.addSubview(headerLabel)
        NSLayoutConstraint.activate([
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            headerLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }

    private func setupSearchBar() {
        view.addSubview(searchBar)
        searchBar.delegate = self
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 8),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        tableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
    }

    private func setupActivityIndicator() {
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.onArticlesUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.onLoadingStateChanged = { [weak self] isLoading in
            DispatchQueue.main.async {
                if isLoading {
                    self?.activityIndicator.startAnimating()
                } else {
                    self?.activityIndicator.stopAnimating()
                }
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self?.present(alert, animated: true)
            }
        }
    }

    // MARK: - Fetch
    private func fetchArticles() {
        Task {
            await viewModel.fetchArticles()
        }
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ArticlesListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let dataSource = isSearching ? filteredArticles : viewModel.articles
        return dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dataSource = isSearching ? filteredArticles : viewModel.articles
        let article = dataSource[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ArticleCell.reuseIdentifier, for: indexPath) as? ArticleCell else {
            return UITableViewCell()
        }
        
        cell.configure(with: article)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let dataSource = isSearching ? filteredArticles : viewModel.articles
        let selectedArticle = dataSource[indexPath.row]
        let detailVC = ArticleDetailViewController(article: selectedArticle)
        navigationController?.view.layer.add(CATransition.fade(duration: 0.3), forKey: nil) // Extra Animation
        navigationController?.pushViewController(detailVC, animated: false)
    }
}

// MARK: - UISearchBarDelegate
extension ArticlesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            isSearching = false
            tableView.reloadData()
            return
        }

        isSearching = true
        filteredArticles = viewModel.articles.filter {
            $0.title.lowercased().contains(searchText.lowercased())
        }
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        isSearching = false
        tableView.reloadData()
    }
}
