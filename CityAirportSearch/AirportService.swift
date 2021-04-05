//
//  AirportService.swift
//  CityAirportSearch
//
//  Created by Valeriy Kovalevskiy on 2.04.21.
//

import RxSwift
import Alamofire

class AirportService {
    private lazy var httpService = AirportHttpService()
    static let shared: AirportService = AirportService()
}

extension AirportService: AirportApi {
    
    func fetchAirports() -> Single<AirportsResponse> {
        return Single.create { [httpService] single -> Disposable in
            do {
                try AirportHttpRouter.getAirports
                    .request(usingHttpService: httpService)
                    .responseJSON { result in
                        
                        do {
                            let airports = try AirportService.parse(result: result)
                            single(.success(airports))
                        }
                        
                        catch {
                            single(.error(error))
                        }
                    }
                }
            catch {
                single(.error(CustomError.error(message: "Airports fetch failure")))
            }
            
            return Disposables.create()
        }
    }
}

extension AirportService {
    static func parse(result: AFDataResponse<Any>) throws -> AirportsResponse {
        guard
            let data = result.data,
            let airportsResponse = try? JSONDecoder().decode(AirportsResponse.self, from: data)
        else {
            throw CustomError.error(message: "Invalid JSON")
        }
        
        return airportsResponse
    }
}
