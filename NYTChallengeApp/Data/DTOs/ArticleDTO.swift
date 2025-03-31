//
//  ArticleDTO.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

struct ArticlesResponse: Codable {
    let results: [ArticleDTO]
}

struct ArticleDTO: Codable {
    let id: Int
    let title: String
    let byline: String
    let publishedDate: String
    let abstract: String
    let url: String
    let media: [MediaDTO]?

    enum CodingKeys: String, CodingKey {
        case id, title, byline, abstract, url, media
        case publishedDate = "published_date"
    }
}

struct MediaDTO: Codable {
    let mediaMetadata: [MediaMetadataDTO]

    enum CodingKeys: String, CodingKey {
        case mediaMetadata = "media-metadata"
    }
}

struct MediaMetadataDTO: Codable {
    let url: String
    let format: String
}
