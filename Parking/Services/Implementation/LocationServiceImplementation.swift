//
//  LocationServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/23/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

final class LocationServiceImplementation : NSObject, CLLocationManagerDelegate, LocationService, Disposable {
    fileprivate var locationManager: CLLocationManager!
    fileprivate var callback: ((LocationServiceResult) -> Void)!
    fileprivate var desiredAccuracy: Double
    
    init(manager: CLLocationManager, accuracy: Double) {
        self.locationManager = manager
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.desiredAccuracy = accuracy
    }
    
    convenience init(accuracy: Double) {
        self.init(manager: CLLocationManager(), accuracy: accuracy)
    }
    
    convenience override init() {
        self.init(accuracy: 100)
    }
    
    internal func fetchCurrentLocation(_ callback: @escaping (LocationServiceResult) -> Void) -> Disposable? {
        
        Log("Current location fetch initiated")
        
        self.callback = callback
        
        self.locationManager.desiredAccuracy = self.desiredAccuracy
        self.locationManager.delegate = self
        
        let authorizationStatus = type(of: self.locationManager!).authorizationStatus()
        
        if (authorizationStatus == .notDetermined) {
            Log("Location services authorization status not determined")
            
            if let _ = Bundle.main.object(forInfoDictionaryKey: "NSLocationAlwaysUsageDescription") {
                Log("Location services 'NSLocationAlwaysUsageDescription' key found")
                self.locationManager.requestAlwaysAuthorization()
                
            } else if let _ = Bundle.main.object(forInfoDictionaryKey: "NSLocationWhenInUseUsageDescription") {
                Log("Location services 'NSLocationWhenInUseUsageDescription' key found")
                self.locationManager.requestWhenInUseAuthorization()
                
            } else {
                Log("No location usage description key found")
                self.callback(LocationServiceResult.failure(LocationServiceError.unknown))
                self.callback = nil
            }
        } else {
            Log("Location services authorization status determined")
            handleAuthorizationStatus(authorizationStatus)
        }
        
        return self
    }
    
    fileprivate func handleAuthorizationStatus(_ status: CLAuthorizationStatus) {
        switch status {
            
        case .denied, .restricted:
            self.callback(LocationServiceResult.failure(LocationServiceError.notAuthorized))
            self.callback = nil
            
        case .authorizedAlways, .authorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            break
        }
    }
    
    //  MARK: CLLocationManagerDelegate
    
    @objc func locationManager(_: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.handleAuthorizationStatus(status)
    }
    
    @objc func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let accurateEnoughLocations = locations.filter { $0.horizontalAccuracy <= self.desiredAccuracy }.sorted { (first: CLLocation, second: CLLocation) -> Bool in
            return first.horizontalAccuracy < second.horizontalAccuracy
        }
        
        if let mostAccurateLocation = accurateEnoughLocations.first {
            self.locationManager.stopUpdatingLocation()
            self.callback(LocationServiceResult.success(mostAccurateLocation))
            self.callback = nil
        }
    }
    
    @objc func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        // FIXME: handle actual NSError value
        self.callback(LocationServiceResult.failure(LocationServiceError.notAuthorized))
    }
    
    //  MARK: Disposable
    
    func dispose() {
        self.locationManager.stopUpdatingLocation()
        
        self.callback = nil
        self.locationManager = nil
    }
}
