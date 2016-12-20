//
//  LocationServiceTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/15/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Parking

class LocationServiceTests: BaseTests {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testNotAuthorizedStatus() {
        class LocationManagerMock: CLLocationManager {
            override fileprivate func startUpdatingLocation() {
                // Empty implementation
            }
        }
        
        // Restricted
        let firstExpectation = self.expectation(description: "firstExpectation")
        
        class LocationManagerRestrictedMock: LocationManagerMock {
            override class func authorizationStatus() -> CLAuthorizationStatus {
                return .restricted
            }
        }

        let restrictedMock = LocationManagerRestrictedMock()
        let serviceUnderTestFirst: LocationService = LocationServiceImplementation(manager: restrictedMock, accuracy: 20.0)
    
        serviceUnderTestFirst.fetchCurrentLocation { result -> Void in
            switch result {
            case LocationServiceResult.success(_):
                XCTFail("No location should be fetched")
                
            case LocationServiceResult.failure(let error):
                XCTAssertNotNil(error)
                
                let errorValue = error as! LocationServiceError
                XCTAssertEqual(errorValue, LocationServiceError.notAuthorized)
            }
            
            firstExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { error -> Void in
            XCTAssertNil(error, "Expectation should succeed")
        }
        
        // Denied
        let secondExpectation = self.expectation(description: "secondExpectation")
        
        class LocationManagerDeniedMock: LocationManagerMock {
            override class func authorizationStatus() -> CLAuthorizationStatus {
                return .denied
            }
        }
        
        let deniedMock = LocationManagerDeniedMock()
        let serviceUnderTestSecond: LocationService = LocationServiceImplementation(manager: deniedMock, accuracy: 20.0)
        serviceUnderTestSecond.fetchCurrentLocation { result -> Void in
            
            switch result {
            case LocationServiceResult.success(_):
                XCTFail("No location should be fetched")
                
            case LocationServiceResult.failure(let error):
                XCTAssertNotNil(error)
                
                let errorValue = error as! LocationServiceError
                XCTAssertEqual(errorValue, LocationServiceError.notAuthorized)
            }
            
            secondExpectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { error -> Void in
            XCTAssertNil(error, "Expectation should succeed")
        }
    }
}
