//
//  LocationService.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/15/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

enum LocationServiceError: Error {
    case unknown
    case notAuthorized
}

enum LocationServiceResult {
    case success(CLLocation?)
    case failure(Error)
}

protocol LocationService {
    @discardableResult func fetchCurrentLocation(_ callback: @escaping (LocationServiceResult) -> Void) -> Disposable?
}
