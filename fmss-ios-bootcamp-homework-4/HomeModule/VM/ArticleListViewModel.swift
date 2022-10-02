//
//  ArticleListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ArticleListViewModelViewProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
 
}

class ArticleListViewModel {
    private let model = ArticleListModel()
    
    weak var viewDelegate: ArticleListViewModelViewProtocol?
    
    init() {
        model.delegate = self
    }
    
    // view yüklendiyse data çek
    func didViewLoad() {
        model.fetchData()
    }
    
    func NumberOfItems() -> Int {
        return model.articles.count
    }
    
    func getModel(at index: Int) -> ArticleCellEntity {
        let article = model.articles[index]
        
        return transformArticleToArticleCellEntity(from: article)
    }
    
    private func transformArticleToArticleCellEntity(from article: Article) -> ArticleCellEntity {
        let id = "\(article.id)"
        return ArticleCellEntity(id: id, content: article.content, category: article.category, image: article.image)
    }
}

// MARK: - PostListModel Delegate Methods
extension ArticleListViewModel: ArticleListModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            // TODO:
        }
    }
}
