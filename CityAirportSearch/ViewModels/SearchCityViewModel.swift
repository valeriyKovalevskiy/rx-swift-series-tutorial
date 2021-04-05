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
    typealias Input = (
        searchText: Driver<String>, ()
    )
    typealias Output = (
        cities: Driver<[CityItemsSection]>, ()
    )
    
    var input: SearchCityViewPresentable.Input { get }
    var output: SearchCityViewPresentable.Output { get }
}

class SearchCityViewModel: SearchCityViewPresentable {
    
    typealias State = (airports: BehaviorRelay<Set<AirportModel>>, ())
    
    
    var input: SearchCityViewPresentable.Input
    var output: SearchCityViewPresentable.Output
    
    private let airportService: AirportApi
    private let disposeBag = DisposeBag()
    private let state: State = (airports: BehaviorRelay<Set<AirportModel>>(value: []), ())
    
    
    init(input: SearchCityViewPresentable.Input,
         airportService: AirportApi) {
        self.input = input
        self.output = SearchCityViewModel.output(input: self.input,
                                                 state: self.state)
        self.airportService = airportService
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
            .map { Set($0) }
            .map { [state] in state.airports.accept($0) }
            .subscribe()
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
