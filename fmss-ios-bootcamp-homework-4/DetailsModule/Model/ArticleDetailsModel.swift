//
//  ArticleDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ArticleDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

class ArticleDetailsModel {
    weak var delegate: ArticleDetailsModelProtocol?
    
    var selectedArticle: Article?
    
    func fetchDataBy(id: String) {
        guard let path = Bundle.main.path(forResource: "articles", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Articles.self, from: data)
            
            let articleById = result.filter {
                if $0.content == id {
                    return true
                } else {
                    return false
                }}
            
            selectedArticle = articleById.first
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
