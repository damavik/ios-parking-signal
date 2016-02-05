//
//  GeocoderService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

enum GeocoderServiceError: ErrorType {
    case Unknown(String?)
    case OverQueryLimit(String?)
    case RequestDenied(String?)
    case InvalidRequest(String?)
}

enum GeocoderServiceResult {
    case Success(Address?)
    case Failure(ErrorType)
}

enum GeocoderServiceLanguage : String {
    case English = "en"
    case Russian = "ru"
}

protocol GeocoderService {
    func fetchAddress(location: CLLocation, language: GeocoderServiceLanguage, callback: GeocoderServiceResult -> Void) -> Disposable?
}