//
//  LocationService.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/15/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

enum LocationServiceError: ErrorType {
    case Unknown
    case NotAuthorized
}

enum LocationServiceResult {
    case Success(CLLocation?)
    case Failure(ErrorType)
}

protocol LocationService {
    func fetchCurrentLocation(callback: LocationServiceResult -> Void) -> Disposable?
}