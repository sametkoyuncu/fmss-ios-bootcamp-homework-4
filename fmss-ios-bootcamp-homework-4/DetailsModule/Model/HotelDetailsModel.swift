//
//  HotelDetailsModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 2.10.2022.
//

import Foundation

protocol HotelDetailsModelProtocol: AnyObject {
    func didDataFetchProcessFinish(_ isSuccess: Bool)
    func didDataAddProcessFinish(_ isSuccess: Bool)
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
        data.setValue(item.type.rawValue, forKey: #keyPath(Item.type))
        data.setValue(Date(), forKey: #keyPath(Item.date))
        
        AppDelegate.sharedAppDelegate.coreDataStack.saveContext()
        
        delegate?.didDataAddProcessFinish(true)
        
    }
}
