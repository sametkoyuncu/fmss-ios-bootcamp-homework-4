//
//  ArticleListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ArticleListViewModelViewProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
    func didItemAdded(isSuccess: Bool, row: Int)
    func didItemRemoved(isSuccess: Bool, row: Int)
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
        // MARK: - async olmalı mı? bence olmalı gibi
        let isFavorite = model.isFavorite(by: article.content!)
    
        return transformArticleToArticleCellEntity(from: article, isFavorite: isFavorite)
    }
    
    func removeFromFavoritesBy(id: String, row: Int) {
        model.removeData(by: id, row: row)
    }
    
    func didBookmarkButtonPressed(newItem: BookmarkItem, row: Int) {
        model.addItem(newItem,  row: row)
    }
    
    private func transformArticleToArticleCellEntity(from article: Article, isFavorite: Bool) -> ArticleCellEntity {
        return ArticleCellEntity(id: article.content,
                                 title: article.title,
                                 content: article.content,
                                 category: article.category,
                                 image: article.image,
                                 isFavorite: isFavorite)
    }
}

// MARK: - Articles Delegate Methods
extension ArticleListViewModel: ArticleListModelProtocol {
    func didDataRemoveProcessFinish(_ isSuccess: Bool, row: Int) {
        viewDelegate?.didItemRemoved(isSuccess: isSuccess, row: row)
    }
    
    func didDataAddProcessFinish(_ isSuccess: Bool, row: Int) {
        viewDelegate?.didItemAdded(isSuccess: isSuccess, row: row)
    }
    
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didCellItemFetch(isSuccess: isSuccess)
    }
}
