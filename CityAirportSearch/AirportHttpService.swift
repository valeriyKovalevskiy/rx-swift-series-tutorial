//
//  AirportHttpService.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import Alamofire

class AirportHttpService: HttpService {
    var sessionManager: Session = Session.default
    
    func request(_ urlRequest: URLRequestConvertible) -> DataRequest {
        sessionManager
            .request(urlRequest)
            .validate(statusCode: 200..<400)
    }
    
    
}
