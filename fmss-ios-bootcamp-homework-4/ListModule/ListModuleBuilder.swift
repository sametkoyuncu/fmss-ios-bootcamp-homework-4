//
//  ListModuleBuilder.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 4.10.2022.
//

import UIKit

struct ListModuleBuilder {
    static func createModule(for model: DataTypeEnum, vc: ListViewController) -> UIViewController {
        let vc = vc
        vc.dataType = model
        // veri tipine göre ilgili view model ve model birbirine bağlanıyor
        switch model {
        case .flights:
            let model = FlightListModel()
            let vm = FlightListViewModel(model: model)
            vc.listViewModel = vm
            vm.viewDelegate = vc
            return vc
        case .hotels:
            let model = HotelListModel()
            let vm = HotelListViewModel(model: model)
            vc.listViewModel = vm
            vm.viewDelegate = vc
            return vc
        case .articles:
            fatalError("articles not found in list module")
        }
    }
}
