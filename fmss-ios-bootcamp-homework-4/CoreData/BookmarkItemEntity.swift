//
//  BookmarkItemEntity.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation

struct BookmarkItem {
    var id: UUID?
    var idForSearch: String?
    var title: String?
    var description: String?
    var image: String?
    var type: DetailsTypeEnum?
}
