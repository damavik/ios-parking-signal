//
//  AddressManager.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

enum AddressManagerError: ErrorType {
    case Unknown(NSError?)
}

enum AddressManagerResult {
    case Success(Address?)
    case Failure(ErrorType)
}

class AddressManager : NSObject {    
    private let locationService: LocationService!
    private let geocoderService: GeocoderService!
    
    init(locationService: LocationService, geocoderService: GeocoderService) {
        self.locationService = locationService
        self.geocoderService = geocoderService
    }
    
    convenience init(locationService: LocationService) {
        let geocoderService = ServiceFactory.geocodeService()
        self.init(locationService: locationService, geocoderService: geocoderService)
    }
    
    convenience override init() {
        let locationService = ServiceFactory.locationService()
        let geocoderService = ServiceFactory.geocodeService()
        self.init(locationService: locationService, geocoderService: geocoderService)
    }
    
    func fetchCurrentAddress(callback: (AddressManagerResult) -> Void) {
        
        self.locationService.fetchCurrentLocation { locationResult -> Void in
            
            switch locationResult {
            case LocationServiceResult.Success(let location?):
                
                self.geocoderService.fetchAddress(location, language: GeocoderServiceLanguage.Russian, callback: { result -> Void in
                    switch result {
                    case GeocoderServiceResult.Success(let address):
                        callback(AddressManagerResult.Success(address))
                        
                    case GeocoderServiceResult.Failure(let error):
                        callback(AddressManagerResult.Failure(error))
                    }
                })
                
            case LocationServiceResult.Failure(let error):
                callback(AddressManagerResult.Failure(error))
                
            default:
                break
            }
        }
    }
}