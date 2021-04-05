//
//  AirportsViewModel.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import RxSwift
import RxCocoa
import RxDataSources

// datasourse; pass it to output
typealias AirportItemsSection = SectionModel<Int, AirportViewPresentable>

protocol AirportsViewPresentable {
    typealias Output = (title: Driver<String>, airports: Driver<[AirportItemsSection]>)
    typealias Input = ()
    typealias Dependencies = (title: String, models: Set<AirportModel>)
    typealias ViewModelBuilder = (AirportsViewPresentable.Input) -> AirportsViewPresentable
    
    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

struct AirportsViewModel: AirportsViewPresentable {
    
    // MARK: - Properties
    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input
    
    init(input: AirportsViewPresentable.Input,
         dependencies: AirportsViewPresentable.Dependencies) {
        self.input = input
        self.output = AirportsViewModel.output(dependencies: dependencies)
    }
}

private extension AirportsViewModel {
    static func output(dependencies: AirportsViewPresentable.Dependencies) -> AirportsViewPresentable.Output {
        
        let airports = Driver.just(dependencies.models)
            .map { models -> [AirportViewModel] in
                models.compactMap { AirportViewModel(usingModel: $0) }
            }
            .map { items -> [AirportItemsSection] in
                ([AirportItemsSection(model: 0, items: items)])
            }
            
        return (
            title: Driver.just(dependencies.title),
            airports: airports
        )
    }
}
