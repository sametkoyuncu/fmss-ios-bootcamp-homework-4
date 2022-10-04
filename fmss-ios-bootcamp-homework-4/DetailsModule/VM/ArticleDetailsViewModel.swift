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
    
    // MARK: - Section Heading
    deinit {
        model.delegate = nil
        viewDelegate = nil
    }
    
    private func transformArticleToDetailsScreenEntity(from article: Article) -> DetailsScreenEntity {
        return DetailsScreenEntity(id: article.id, cellTitle: article.title, desc: article.content, image: article.image, category: article.category)
    }
}

// MARK: - Model Protocol Methods
extension ArticleDetailsViewModel: ArticleDetailsModelProtocol {
    func didDataAddProcessFinish(_ isSuccess: Bool) {
        // TODO: Section Heading
    }
    
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            // TODO:
        }
    }
}


// MARK: - View Model Methods Protocol
extension ArticleDetailsViewModel: DetailsViewModelMethodsProtocol {
    func didSaveButtonPressed(newItem: BookmarkItem) {
        model.addItem(newItem)
    }
    
    func didViewLoad() {
        model.fetchData()
    }
    
    func getModel() -> DetailsScreenEntity {
        // TODO:
        let article = model.selectedArticle!
        
        return transformArticleToDetailsScreenEntity(from: article)
    }
}
