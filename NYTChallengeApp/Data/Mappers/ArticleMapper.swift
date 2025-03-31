//
//  ArticleMapper.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

extension ArticleDTO { // Clean and Get me Article
    func toDomain() -> Article {
        Article(
            id: id,
            title: title,
            byline: byline,
            publishedDate: publishedDate,
            abstract: abstract,
            url: url,
            imageUrl: media?.first?.mediaMetadata.first?.url
        )
    }
}
