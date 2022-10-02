//
//  ArticleEntity.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

// MARK: - Article
struct Article: Codable {
    let id, title, content, category, image: String?
}

typealias Articles = [Article]
