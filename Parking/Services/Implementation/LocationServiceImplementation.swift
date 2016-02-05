//
//  LocationServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/23/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import CoreLocation

final class LocationServiceImplementation : NSObject, CLLocationManagerDelegate, LocationService, Disposable {
    private var locationManager: CLLocationManager!
    private var callback: (LocationServiceResult -> Void)!
    private var desiredAccuracy: Double
    
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
    
    func fetchCurrentLocation(callback: LocationServiceResult -> Void) -> Disposable? {
        
        Log("Current location fetch initiated")
        
        self.callback = callback
        
        self.locationManager.desiredAccuracy = self.desiredAccuracy
        self.locationManager.delegate = self
        
        let authorizationStatus = self.locationManager!.dynamicType.authorizationStatus()
        
        if (authorizationStatus == .NotDetermined) {
            Log("Location services authorization status not determined")
            
            if let _ = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") {
                Log("Location services 'NSLocationAlwaysUsageDescription' key found")
                self.locationManager.requestAlwaysAuthorization()
                
            } else if let _ = NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") {
                Log("Location services 'NSLocationWhenInUseUsageDescription' key found")
                self.locationManager.requestWhenInUseAuthorization()
                
            } else {
                Log("No location usage description key found")
                self.callback(LocationServiceResult.Failure(LocationServiceError.Unknown))
                self.callback = nil
            }
        } else {
            Log("Location services authorization status determined")
            handleAuthorizationStatus(authorizationStatus)
        }
        
        return self
    }
    
    private func handleAuthorizationStatus(status: CLAuthorizationStatus) {
        switch status {
            
        case .Denied, .Restricted:
            self.callback(LocationServiceResult.Failure(LocationServiceError.NotAuthorized))
            self.callback = nil
            
        case .AuthorizedAlways, .AuthorizedWhenInUse:
            self.locationManager.startUpdatingLocation()
            
        default:
            break
        }
    }
    
    //  MARK: CLLocationManagerDelegate
    
    @objc func locationManager(_: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.handleAuthorizationStatus(status)
    }
    
    @objc func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let accurateEnoughLocations = locations.filter { $0.horizontalAccuracy <= self.desiredAccuracy }.sort { (first: CLLocation, second: CLLocation) -> Bool in
            return first.horizontalAccuracy < second.horizontalAccuracy
        }
        
        if let mostAccurateLocation = accurateEnoughLocations.first {
            self.locationManager.stopUpdatingLocation()
            self.callback(LocationServiceResult.Success(mostAccurateLocation))
            self.callback = nil
        }
    }
    
    @objc func locationManager(_: CLLocationManager, didFailWithError error: NSError) {
        // FIXME: handle actual NSError value
        self.callback(LocationServiceResult.Failure(LocationServiceError.NotAuthorized))
    }
    
    //  MARK: Disposable
    
    func dispose() {
        self.locationManager.stopUpdatingLocation()
        
        self.callback = nil
        self.locationManager = nil
    }
}