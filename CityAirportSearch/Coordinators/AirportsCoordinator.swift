//
//  AirportsCoordinator.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import UIKit

final class AirportsCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    private let models: Set<AirportModel>
    
    init(models: Set<AirportModel>, navigationController: UINavigationController) {
        self.models = models
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = AirportsViewController.instantiate()
        
        viewController.viewModelBuilder = { [models] input in
            
            let title = models.first?.city ?? ""
            return AirportsViewModel(input: input, dependencies: (title: title, models: self.models))
        }
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
