//
//  AirportsViewModel.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import Foundation

protocol AirportsViewPresentable {
    typealias Output = ()
    typealias Input = ()
    
    var output: AirportsViewPresentable.Output { get }
    var input: AirportsViewPresentable.Input { get }
}

struct AirportsViewModel: AirportsViewPresentable {
    
    // MARK: - Properties
    var output: AirportsViewPresentable.Output
    var input: AirportsViewPresentable.Input
}
