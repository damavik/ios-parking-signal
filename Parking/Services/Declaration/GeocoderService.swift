//
//  GeocoderService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

enum GeocoderServiceError: Error {
    case unknown(String?)
    case overQueryLimit(String?)
    case requestDenied(String?)
    case invalidRequest(String?)
}

enum GeocoderServiceResult {
    case success(Address?)
    case failure(Error)
}

enum GeocoderServiceLanguage : String {
    case english = "en"
    case russian = "ru"
}

protocol GeocoderService {
    @discardableResult func fetchAddress(_ location: CLLocation, language: GeocoderServiceLanguage, callback: @escaping (GeocoderServiceResult) -> Void) -> Disposable?
}
