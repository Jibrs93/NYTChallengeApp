//
//  ArticleDetailViewController.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import UIKit
import SafariServices

final class ArticleDetailViewController: UIViewController {
    private let article: Article

    private let scrollView = UIScrollView()
    private let contentView = UIView()

    private let imageView = UIImageView()
    private let titleLabel = UILabel()
    private let bylineLabel = UILabel()
    private let dateLabel = UILabel()
    private let abstractLabel = UILabel()
    private let openInSafariButton = UIButton(type: .system)

    // MARK: - Init
    init(article: Article) {
        self.article = article
        super.init(nibName: nil, bundle: nil)
        self.title = "Detalle"
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        configure()
    }

    // MARK: - Setup
    private func setupUI() {
        // ScrollView
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        [imageView, titleLabel, bylineLabel, dateLabel, abstractLabel, openInSafariButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8

        titleLabel.font = .preferredFont(forTextStyle: .title2)
        titleLabel.numberOfLines = 0

        bylineLabel.font = .preferredFont(forTextStyle: .subheadline)
        bylineLabel.textColor = .secondaryLabel

        dateLabel.font = .preferredFont(forTextStyle: .caption1)
        dateLabel.textColor = .tertiaryLabel

        abstractLabel.font = .preferredFont(forTextStyle: .body)
        abstractLabel.numberOfLines = 0

        openInSafariButton.setTitle("Leer artículo completo", for: .normal)
        openInSafariButton.addTarget(self, action: #selector(openInSafari), for: .touchUpInside)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            imageView.heightAnchor.constraint(equalToConstant: 200),

            titleLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 16),
            titleLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),

            bylineLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            bylineLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            bylineLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            dateLabel.topAnchor.constraint(equalTo: bylineLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            abstractLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 16),
            abstractLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            abstractLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            openInSafariButton.topAnchor.constraint(equalTo: abstractLabel.bottomAnchor, constant: 24),
            openInSafariButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            openInSafariButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }

    private func configure() {
        titleLabel.text = article.title
        bylineLabel.text = article.byline
        dateLabel.text = article.publishedDate
        abstractLabel.text = article.abstract

        if let urlString = article.imageUrl, let url = URL(string: urlString) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url),
                   let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                }
            }
        }
    }

    // MARK: - Actions
    @objc private func openInSafari() {
        guard let url = URL(string: article.url) else { return }
        let safariVC = SFSafariViewController(url: url)
        present(safariVC, animated: true)
    }
}

