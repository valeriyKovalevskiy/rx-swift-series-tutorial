//
//  CityViewModel.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import Foundation
import RxDataSources

typealias CityItemsSection = SectionModel<Int, CityViewPresentable>

protocol CityViewPresentable {
    var city: String { get }
    var location: String { get }
}

struct CityViewModel: CityViewPresentable {
    var city: String
    var location: String
    
    init(model: AirportModel) {
        self.city = model.city
        self.location = "\(model.state ?? ""), \(model.country)"
    }
}

extension CityViewModel: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(city)
    }
}

extension CityViewModel: Equatable {
    static func == (lhs: CityViewModel, rhs: CityViewModel) -> Bool {
        return lhs.city == rhs.city
    }
}
