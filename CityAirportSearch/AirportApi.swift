//
//  AirportApi.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import RxSwift

protocol AirportApi {
    func fetchAirports() -> Single<AirportsResponse>
}
