//
//  ArticleDetailsViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

class ArticleDetailsViewModel {
    private let model = ArticleDetailsModel()
    
    weak var viewDelegate: DetailsViewModelViewDelegateProtocol?
    
    init() {
        model.delegate = self
    }
    
    private func transformArticleToDetailsScreenEntity(from article: Article) -> DetailsScreenEntity {
        return DetailsScreenEntity(cellTitle: article.title, desc: article.content, image: article.image, category: article.category)
    }
}

// MARK: - Model Protocol Methods
extension ArticleDetailsViewModel: ArticleDetailsModelProtocol {
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
    func didViewLoad(_ selectedId: String) {
        model.fetchDataBy(id: selectedId)
    }
    
    func getModel() -> DetailsScreenEntity {
        // TODO:
        let article = model.selectedArticle!
        
        return transformArticleToDetailsScreenEntity(from: article)
    }
}
