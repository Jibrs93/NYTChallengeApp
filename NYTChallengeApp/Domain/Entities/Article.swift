//
//  Article.swift
//  NYTChallengeApp
//
//  Created by Jonathan Lopez on 28/03/25.
//

import Foundation

struct Article: Codable {
    let id: Int
    let title: String
    let byline: String
    let publishedDate: String
    let abstract: String
    let url: String
    let imageUrl: String?
}
