//
//  ArticleDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class ArticleDetailsViewModel {
    private let model: ArticleDetailsModel
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init(model _model: ArticleDetailsModel) {
        model = _model
        model.delegate = self
    }
    
    private func transformArticleToDetailsScreenEntity(from article: Article) -> DetailsScreenEntity {
        return DetailsScreenEntity(id: article.content,
                                   cellTitle: article.title,
                                   desc: article.content,
                                   image: article.image,
                                   category: article.category)
    }
}

// MARK: - Model Protocol Methods
extension ArticleDetailsViewModel: DetailsModelDelegateProtocol {
    func didDataRemoveProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didItemRemoved(isSuccess: isSuccess)
    }
    
    func didCheckFavoriteProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didFavoriteCheck(isSuccess: isSuccess)
    }
    
    func didDataAddProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didItemAdded(isSuccess: isSuccess)
    }
    
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        viewDelegate?.didCellItemFetch(isSuccess: isSuccess)
    }
}


// MARK: - View Model Methods Protocol
extension ArticleDetailsViewModel: DetailsViewModelMethodsProtocol {
    func removeFromFavoritesBy(id: String) {
        model.removeData(by: id)
    }
    
    func didSaveButtonPressed(newItem: BookmarkItem) {
        model.addItem(newItem)
    }
    
    func didViewLoad() {
        model.fetchData()
    }
    
    func getModel() -> DetailsScreenEntity {
        // TODO:
        let article = model.selectedArticle!
        
        model.isFavorite(by: article.content!)
        return transformArticleToDetailsScreenEntity(from: article)
    }
}
