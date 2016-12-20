//
//  AddressManager.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

enum AddressManagerError: Error {
    case unknown(NSError?)
}

enum AddressManagerResult {
    case success(Address?)
    case failure(Error)
}

class AddressManager : NSObject {    
    fileprivate let locationService: LocationService!
    fileprivate let geocoderService: GeocoderService!
    
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
    
    func fetchCurrentAddress(_ callback: @escaping (AddressManagerResult) -> Void) {
        
        self.locationService.fetchCurrentLocation { locationResult -> Void in
            
            switch locationResult {
            case LocationServiceResult.success(let location?):
                
                self.geocoderService.fetchAddress(location, language: GeocoderServiceLanguage.russian, callback: { result -> Void in
                    switch result {
                    case GeocoderServiceResult.success(let address):
                        callback(AddressManagerResult.success(address))
                        
                    case GeocoderServiceResult.failure(let error):
                        callback(AddressManagerResult.failure(error))
                    }
                })
                
            case LocationServiceResult.failure(let error):
                callback(AddressManagerResult.failure(error))
                
            default:
                break
            }
        }
    }
}
