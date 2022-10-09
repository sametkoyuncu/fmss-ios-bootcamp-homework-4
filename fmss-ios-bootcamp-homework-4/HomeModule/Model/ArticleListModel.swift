//
//  ArticlesModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation
import CoreData

protocol ArticleListModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
    func didDataAddProcessFinish(_ isSuccess: Bool, row: Int)
    func didDataRemoveProcessFinish(_ isSuccess: Bool, row: Int)
}

class ArticleListModel {
    weak var delegate: ArticleListModelProtocol?
    
    var articles: Articles = []
    // tüm article'ları çek
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
    
    // article'ı coredata'ya ekle
    func addItem(_ item: BookmarkItem, row: Int) {
        let managedContext = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
        
        let data = Item(context: managedContext)
        
        data.setValue(UUID(), forKey: "id")
        data.setValue(item.idForSearch, forKey: #keyPath(Item.idForSearch))
        data.setValue(item.title, forKey: #keyPath(Item.title))
        data.setValue(item.description, forKey: #keyPath(Item.desc))
        data.setValue(item.image, forKey: #keyPath(Item.image))
        data.setValue("articles", forKey: #keyPath(Item.type))
        data.setValue(Date(), forKey: #keyPath(Item.date))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        delegate?.didDataAddProcessFinish(true, row: row)
    }
    
    // article'ı coredata'dan sil
    func removeData(by id: String, row: Int) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "(idForSearch = %@)", id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let result = try context.fetch(fetchRequest).first
            
            if let result = result {
                context.delete(result)
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                
                delegate?.didDataRemoveProcessFinish(true, row: row)
            }
        } catch {
            delegate?.didDataRemoveProcessFinish(false, row: row)
            print(error.localizedDescription)
        }
    }
    
    // article bookmarks'a eklenmiş mi, eklenmemiş mi onun kontrolü
    func isFavorite(by id: String) -> Bool {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "(idForSearch = %@)", id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let result = try context.fetch(fetchRequest).first
            // if let olabilir
            guard let _ = result else {
                return false
            }
            return true
        } catch {
            print(error.localizedDescription)
            return false
        }
    }
}
