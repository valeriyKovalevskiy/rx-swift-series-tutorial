//
//  AirportViewModel.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 5.04.21.
//

import Foundation

protocol AirportViewPresentable {
    var name: String { get }
    var code: String { get }
    var address: String { get }
    var distance: Double? { get }
    var formattedDistance: String { get }
    var runwayLength: String { get }
    var location: (lat: String, lon: String) { get }
}

struct AirportViewModel: AirportViewPresentable {
    
    var formattedDistance: String {
        return "\(distance?.rounded(.toNearestOrEven) ?? 0 / 1000) Km"
    }

    var name: String
    var code: String
    var address: String
    var distance: Double?
    var runwayLength: String
    var location: (lat: String, lon: String)
    
    init(usingModel model: AirportModel) {
        self.name = model.name
        self.code = model.code
        self.address = "\(model.state ?? ""), \(model.country)"
        self.runwayLength = "Runway Length: \(model.runwayLength ?? "N/A")"
        self.location = (lat: model.lat, lon: model.lon)
        
        // FIXME: - Distancing calculation from current location
        self.distance = Double.random(in: 0...100)
    }    
}
