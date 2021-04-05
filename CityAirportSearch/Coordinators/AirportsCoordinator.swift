//
//  AirportsCoordinator.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import UIKit

final class AirportsCoordinator: BaseCoordinator {
    private let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = AirportsViewController.instantiate()
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
