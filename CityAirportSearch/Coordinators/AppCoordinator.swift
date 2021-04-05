//
//  AppCoordinator.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow
    private let navigationController: UINavigationController = {
        let navigationController = UINavigationController()
        let navigationBar = navigationController.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.tintColor = .white
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .customPink
        
        navigationBar.titleTextAttributes = [
            .font: UIFont(name: "Avenir-Medium", size: 28.0)!,
            .foregroundColor: UIColor.white
        ]
        
        return navigationController
    }()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    override func start() {
        let searchCityCoordinator = SearchCityCoordinator(navigationController: navigationController)
        
        self.add(coordinator: searchCityCoordinator)
        searchCityCoordinator.start()
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}
