//
//  HotelDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation
import CoreData

protocol HotelDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
    func didDataAddProcessFinish(_ isSuccess: Bool)
    func didDataRemoveProcessFinish(_ isSuccess: Bool)
    func didCheckFavoriteProcessFinish(_ isSuccess: Bool)
}

class HotelDetailsModel {
    weak var delegate: HotelDetailsModelProtocol?
    
    var selectedHotel: Hotel?
    
    private var id: String
    
    init(id:String) {
        self.id = id
    }
    
    // MARK: -
    deinit {
        delegate = nil
    }
    
    func fetchData() {
        guard let path = Bundle.main.path(forResource: "hotels", ofType: "json") else {
            delegate?.didDataFetchProcessFinish(false)
            return
        }
        
        let file = URL(fileURLWithPath: path)
        
        do {
            let data = try Data(contentsOf: file)
            
            let result = try JSONDecoder().decode(Hotels.self, from: data)
            
            let hotelById = result.filter { $0.id == id }.first
            
            selectedHotel = hotelById
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
        data.setValue("hotels", forKey: #keyPath(Item.type))
        data.setValue(Date(), forKey: #keyPath(Item.date))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        delegate?.didDataAddProcessFinish(true)
        
    }
    
    func removeData(by id: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "(idForSearch = %@)", id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let result = try context.fetch(fetchRequest).first
            
            if let result = result {
                context.delete(result)
                AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
                
                delegate?.didDataRemoveProcessFinish(true)
            } else {
                delegate?.didDataRemoveProcessFinish(true)
            }
        } catch {
            delegate?.didDataRemoveProcessFinish(false)
            print(error.localizedDescription)
        }
    }
    
    func isFavorite(by id: String) {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let predicate = NSPredicate(format: "(idForSearch = %@)", id as CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let context = AppDelegate.sharedAppDelegate.coreDataStack.managedContext
            let result = try context.fetch(fetchRequest).first
            
            guard let _ = result else {
                delegate?.didCheckFavoriteProcessFinish(false)
                return
            }
            delegate?.didCheckFavoriteProcessFinish(true)
            
        } catch {
            delegate?.didCheckFavoriteProcessFinish(false)
            print(error.localizedDescription)
        }
    }
}
