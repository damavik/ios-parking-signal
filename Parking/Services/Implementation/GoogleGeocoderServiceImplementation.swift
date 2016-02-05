//
//  GoogleGeocoderServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

private enum GoogleGeocoderServiceImplementationStatus: String {
    case OK = "OK"
    case ZeroResult = "ZERO_RESULTS"
    case UnknownError = "UNKNOWN_ERROR"
    case OverQueryLimit = "OVER_QUERY_LIMIT"
    case RequestDenied = "REQUEST_DENIED"
    case InvalidRequest = "INVALID_REQUEST"
}

final class GoogleGeocoderServiceImplementation : GeocoderService {
    private let apiKey: String!
    private let networkService: NetworkService!
    private let baseURL = "https://maps.googleapis.com/maps/api/geocode/json"
    
    init(apiKey: String, networkService: NetworkService) {
        self.apiKey = apiKey
        self.networkService = networkService
    }
    
    //  MARK: GeocoderService
    
    func fetchAddress(location: CLLocation, language: GeocoderServiceLanguage, callback: GeocoderServiceResult -> Void) -> Disposable? {
        
        let parameters = self.createParameters(location, language: language)
        
        func unknownFailureCallback() {
            callback(GeocoderServiceResult.Failure(GeocoderServiceError.Unknown(nil)))
        }
        
        return self.networkService.request(.GET, url: self.baseURL, parameters: parameters) { result -> Void in
            switch (result) {
            case let NetworkServiceResult.Success(data):
                
                guard let resultDictionary = data as? Dictionary<String, AnyObject> else {
                    unknownFailureCallback()
                    return
                }
                
                guard let rawStatus = resultDictionary["status"] as? GoogleGeocoderServiceImplementationStatus.RawValue else {
                    unknownFailureCallback()
                    return
                }
                
                guard let status = GoogleGeocoderServiceImplementationStatus(rawValue: rawStatus) else {
                    unknownFailureCallback()
                    return;
                }
                
                let errorMessage = resultDictionary["error_message"] as? String
                
                switch status {
                case .OK:
                    guard let results = resultDictionary["results"] as? Array<Dictionary<String, AnyObject>> where results.count > 0 else {
                        unknownFailureCallback()
                        return
                    }
                    
                    let parsedAddress = GoogleGeocoderResultParser().parseAddress(results[0])
                    callback(GeocoderServiceResult.Success(parsedAddress))
                    
                
                case .ZeroResult:
                    callback(GeocoderServiceResult.Success(nil))
                    
                case .UnknownError:
                    callback(GeocoderServiceResult.Failure(GeocoderServiceError.Unknown(errorMessage)))
                    
                case .OverQueryLimit:
                    callback(GeocoderServiceResult.Failure(GeocoderServiceError.OverQueryLimit(errorMessage)))
                    
                case .RequestDenied:
                    callback(GeocoderServiceResult.Failure(GeocoderServiceError.RequestDenied(errorMessage)))
                    
                case .InvalidRequest:
                    callback(GeocoderServiceResult.Failure(GeocoderServiceError.RequestDenied(errorMessage)))
                }
                
            case NetworkServiceResult.Failure(_):
                // FIXME: handle actual error
                unknownFailureCallback()
            }
        }
    }
    
    private func createParameters(location: CLLocation, language: GeocoderServiceLanguage) -> Dictionary<String, String> {
        return [ "key" : self.apiKey,
            "latlng" : String(format: "%.6f,%.6f", location.coordinate.latitude, location.coordinate.longitude),
            "language" : language.rawValue,
            "location_type" : "ROOFTOP",
            "result_type" : "street_address" ]
    }
}
