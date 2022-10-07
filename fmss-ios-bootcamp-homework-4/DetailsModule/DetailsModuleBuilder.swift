//
//  DetailsModuleBuilder.swift
//  fmss-ios-bootcamp-homework-4
//
//  Created by Samet Koyuncu on 4.10.2022.
//

import UIKit

struct DetailsModuleBuilder {
    static func createModule(with id: String, for model: DataTypeEnum, vc: DetailsViewController) -> UIViewController {
        let vc = vc
        
        // data tipine göre view model ve model'leri setle
        switch model {
        case .flights:
            let model = FlightDetailsModel(id: id)
            let vm = FlightDetailsViewModel(model: model)
            vc.detailsViewModel = vm
            vm.viewDelegate = vc
            return vc
        case .hotels:
            let model = HotelDetailsModel(id: id)
            let vm = HotelDetailsViewModel(model: model)
            vc.detailsViewModel = vm
            vm.viewDelegate = vc
            return vc
        case .articles:
            let model = ArticleDetailsModel(id: id)
            let vm = ArticleDetailsViewModel(model: model)
            vc.detailsViewModel = vm
            vm.viewDelegate = vc
            return vc
        }
    }
}
