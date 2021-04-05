//
//  SearchCityViewModel.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import RxCocoa
import RxSwift
import RxDataSources

protocol SearchCityViewPresentable {
    
    typealias ViewModelBuilder = (SearchCityViewPresentable.Input) -> SearchCityViewPresentable
    typealias Input = ( searchText: Driver<String>, citySelected: Driver<CityViewModel>)
    typealias Output = (cities: Driver<[CityItemsSection]>, ())
    
    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

final class SearchCityViewModel: SearchCityViewPresentable {
    
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    typealias RoutingAction = (citySelectedRelay: PublishRelay<Set<AirportModel>>, ())
    typealias Routing = (citySelected: Driver<Set<AirportModel>>, ())
    
    // MARK: - Properties
    private let airportService: AirportApi
    private let disposeBag = DisposeBag()
    private let state: State = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())
    private let routingAction: RoutingAction = (citySelectedRelay: PublishRelay(), ())
    
    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output

    lazy var router: Routing = (citySelected: routingAction.citySelectedRelay.asDriver(onErrorDriveWith: .empty()), ())

    // MARK: - Init
    init(input: SearchCityViewPresentable.Input,
         airportService: AirportApi) {
        self.input = input
        self.airportService = airportService
        self.output = SearchCityViewModel.output(input: self.input,
                                                 state: self.state)
        self.process()
    }
}

private extension SearchCityViewModel {
    static func output(input: SearchCityViewPresentable.Input,
                       state: State) -> SearchCityViewPresentable.Output {
        
        let searchTextObservable = input.searchText
            .debounce(.milliseconds(300))
            .distinctUntilChanged()
            .skip(1)
            .asObservable()
            .share(replay: 1, scope: .whileConnected)
        
        let airportsObservable = state.airports
            .skip(1)
            .asObservable()
        
        let sections = Observable
            .combineLatest(searchTextObservable, airportsObservable)
            .map { (searchKey, airports) -> Set<AirportModel> in
                return airports.filter { airport -> Bool in
                    !searchKey.isEmpty &&
                        airport.city
                        .lowercased()
                        .replacingOccurrences(of: " ", with: "")
                        .hasPrefix(searchKey.lowercased())
                }
            }
            .map { airportModel -> [CityViewModel] in
                SearchCityViewModel.uniqueElementsFrom(array: airportModel.compactMap {
                    CityViewModel(model: $0)
                })
            }
            .map { cityViewModelArray -> [CityItemsSection] in
                [CityItemsSection(model: 0, items: cityViewModelArray)]
            }
            .asDriver(onErrorJustReturn: [])
        
        return (
            cities: sections, ()
        )
    }
    
    func process() -> Void {
        
        airportService
            .fetchAirports()
            .map { response -> Set<AirportModel> in
                Set(response)
            }
            .map { [state] model in
                state.airports.accept(model)
            }
            .subscribe()
            .disposed(by: disposeBag)
        
        input.citySelected
            .map { viewModel -> String in
                viewModel.city
            }
            .withLatestFrom(state.airports.asDriver()) { city, airports -> (city: String, airports: Set<AirportModel>) in
                (city: city, airports: airports)
            }
            .map { (city, airports) -> Set<AirportModel> in
                airports.filter { $0.city == city }
            }
            .map { [routingAction] airports in
                routingAction.citySelectedRelay.accept(airports)
            }
            .drive()
            .disposed(by: disposeBag)
    }
}

private extension SearchCityViewModel {
    
    static func uniqueElementsFrom(array: [CityViewModel]) -> [CityViewModel] {
        var set = Set<CityViewModel>()
        let result = array.filter {
            guard !set.contains($0) else {
                return false
            }
            
            set.insert($0)
            return true
        }
        return result
    }
}
