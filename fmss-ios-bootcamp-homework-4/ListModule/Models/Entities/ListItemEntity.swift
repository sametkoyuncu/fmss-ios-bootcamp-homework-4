//
//  ListModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class ListItemEntity {
    var id: String?
    var cellTitle: String?
    var desc: String?
    var image: String?
    
    init(id: String?, cellTitle: String?, desc: String?, image: String?) {
        self.id = id
        self.cellTitle = cellTitle
        self.desc = desc
        self.image = image
    }
}
