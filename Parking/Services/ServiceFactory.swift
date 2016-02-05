//
//  ServiceFactory.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/26/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

struct ServiceFactory {
    static func networkService() -> NetworkService {
        return NetworkServiceImplementation()
    }
    
    static func geocodeService() -> GeocoderService {
        return GoogleGeocoderServiceImplementation(apiKey: "AIzaSyBiDuXOPe6ktbRlilNL4nFAQLarY-aMhvs", networkService: self.networkService())
    }
    
    static func locationService() -> LocationService {
        return LocationServiceImplementation(accuracy: 100.0)
    }
    
    static func photoStorageService() -> PhotoStorageService {
        return PhotoStorageServiceImplementation()
    }
    
    static func photoCaptureService() -> PhotoCaptureService {
        return PhotoCaptureServiceImplementation()
    }
    
    static func identityService() -> IdentityService {
        return IdentityServiceImplementation()
    }
    
    static func apiEndpointService() -> APIEndpointService {
        return APIEndpointServiceImplementation()
    }
}
