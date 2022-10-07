//
//  BookmarkListViewModel.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 3.10.2022.
//

import Foundation
protocol BookmarkListViewModelProtocol: AnyObject {
    func didCellItemFetch(isSuccess: Bool)
}

class BookmarkListViewModel {

    private let model = BookmarkListModel()
    
    weak var viewDelegate: BookmarkListViewModelProtocol?
    
    init() {
        model.delegate = self
    }
    
    func viewDidLoad() {
        model.fetchData()
    }
    
    func numberOfItems() -> Int {
        return model.bookmarkList.count
    }

    func getModel(at index: Int) -> BookmarkItem {
        let item =  model.bookmarkList[index]
        
        return transformItemToTodoItem(from: item)
    }

    
    private func transformItemToTodoItem(from item: Item) -> BookmarkItem {
        let type: DataTypeEnum?
        // data type to string
        switch item.type {
        case "hotels":
            type = .hotels
        case "flights":
            type = .flights
        case "articles":
            type = .articles
        case .none, .some(_):
            fatalError("type is not found")
        }

        return BookmarkItem(id: item.id!,
                            idForSearch: item.idForSearch,
                            title: item.title!,
                            description: item.desc!,
                            image: item.image!,
                            type: type)
    }
}

// MARK: - TodoListModel Delegate Methods
extension BookmarkListViewModel: BookmarkListModelProtocol {
    func didDataFetchProcessFinish(_ isSuccess: Bool) {
        if isSuccess {
            viewDelegate?.didCellItemFetch(isSuccess: true)
        } else {
            print("error")
        }
    }
}
