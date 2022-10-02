//
//  ListModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class ListItemEntity {
    var cellTitle: String?
    var desc: String?
    var image: String?
    var category: String?
    
    init(cellTitle: String?, desc: String?, image: String?, category: String?) {
        self.cellTitle = cellTitle
        self.desc = desc
        self.image = image
        self.category = category
    }
}
