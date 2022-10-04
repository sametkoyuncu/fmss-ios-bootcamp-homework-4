//
//  ArticlesModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ArticleListModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

class ArticleListModel {
    weak var delegate: ArticleListModelProtocol?
    
    var articles: Articles = []
    // TODO: 
    deinit {
        delegate = nil
    }
    
    func fetchData() {
        guard let path = Bundle.main.path(forResource: "articles", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)

            let result = try JSONDecoder().decode(Articles.self, from: data)

            articles = result
            delegate?.didDataFetchProcessFinish(true)

        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
