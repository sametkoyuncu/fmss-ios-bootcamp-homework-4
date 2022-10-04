//
//  BookmarksModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation
import CoreData

protocol BookmarkListModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
}

class BookmarkListModel {
    weak var delegate: BookmarkListModelProtocol?
    
    var bookmarkList: [Item] = []
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let sortByDate = NSSortDescriptor(key: #keyPath(Item.date), ascending: false)
        
        fetchRequest.sortDescriptors = [sortByDate]
        
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let results = try context.fetch(fetchRequest)
            bookmarkList = results
            delegate?.didDataFetchProcessFinish(true)
        } catch {
            delegate?.didDataFetchProcessFinish(false)
            print(error.localizedDescription)
        }
    }
   
}
