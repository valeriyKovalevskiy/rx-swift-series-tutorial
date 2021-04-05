//
//  SearchCityCoordinator.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import UIKit
import RxSwift
import RxCocoa

final class SearchCityCoordinator: BaseCoordinator {
    
    private let navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        let viewController = SearchCityViewController.instantiate()
        let airportService = AirportService.shared
        
        viewController.viewModelBuilder = { [disposeBag] in
            let viewModel = SearchCityViewModel(input: $0, airportService: airportService)
            
            viewModel.router.citySelected
                .map { [unowned self] models in
                    self.showAirports(usingModels: models)
                }
                .drive()
                .disposed(by: disposeBag)
            return viewModel
        }
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

private extension SearchCityCoordinator {
    func showAirports(usingModels models: Set<AirportModel>) -> Void {
        
        let airportsCoordinator = AirportsCoordinator(navigationController: self.navigationController)
        self.add(coordinator: airportsCoordinator)
        
        airportsCoordinator.start()
    }
}
