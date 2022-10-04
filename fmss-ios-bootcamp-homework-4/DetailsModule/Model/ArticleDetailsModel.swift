//
//  ArticleDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol ArticleDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
    func didDataAddProcessFinish(_ isSuccess: Bool)
}

class ArticleDetailsModel {
    weak var delegate: ArticleDetailsModelProtocol?
    
    var selectedArticle: Article?
    
    // MARK: -
    deinit {
        delegate = nil
    }
    
    
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
    
    func addItem(_ item: BookmarkItem) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let data = Item(context: managedContext)
        
        data.setValue(UUID(), forKey: "id")
        data.setValue(item.idForSearch, forKey: #keyPath(Item.idForSearch))
        data.setValue(item.title, forKey: #keyPath(Item.title))
        data.setValue(item.description, forKey: #keyPath(Item.desc))
        data.setValue(item.image, forKey: #keyPath(Item.image))
        data.setValue(item.type.rawValue, forKey: #keyPath(Item.type))
        data.setValue(Date(), forKey: #keyPath(Item.date))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        delegate?.didDataAddProcessFinish(true)
        
    }
}
