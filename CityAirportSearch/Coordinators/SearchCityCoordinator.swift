//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import UIKit

final class SearchCityCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = SearchCityViewController.instantiate()
        let airportService = AirportService.shared
        
        viewController.viewModelBuilder = {
            SearchCityViewModel(input: $0, airportService: airportService)
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}
