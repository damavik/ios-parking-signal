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
            override private func startUpdatingLocation() {
                // Empty implementation
            }
        }
        
        // Restricted
        let firstExpectation = self.expectationWithDescription("firstExpectation")
        
        class LocationManagerRestrictedMock: LocationManagerMock {
            override class func authorizationStatus() -> CLAuthorizationStatus {
                return .Restricted
            }
        }

        let restrictedMock = LocationManagerRestrictedMock()
        let serviceUnderTestFirst: LocationService = LocationServiceImplementation(manager: restrictedMock, accuracy: 20.0)
    
        serviceUnderTestFirst.fetchCurrentLocation { result -> Void in
            switch result {
            case LocationServiceResult.Success(_):
                XCTFail("No location should be fetched")
                
            case LocationServiceResult.Failure(let error):
                XCTAssertNotNil(error)
                
                let errorValue = error as! LocationServiceError
                XCTAssertEqual(errorValue, LocationServiceError.NotAuthorized)
            }
            
            firstExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0) { error -> Void in
            XCTAssertNil(error, "Expectation should succeed")
        }
        
        // Denied
        let secondExpectation = self.expectationWithDescription("secondExpectation")
        
        class LocationManagerDeniedMock: LocationManagerMock {
            override class func authorizationStatus() -> CLAuthorizationStatus {
                return .Denied
            }
        }
        
        let deniedMock = LocationManagerDeniedMock()
        let serviceUnderTestSecond: LocationService = LocationServiceImplementation(manager: deniedMock, accuracy: 20.0)
        serviceUnderTestSecond.fetchCurrentLocation { result -> Void in
            
            switch result {
            case LocationServiceResult.Success(_):
                XCTFail("No location should be fetched")
                
            case LocationServiceResult.Failure(let error):
                XCTAssertNotNil(error)
                
                let errorValue = error as! LocationServiceError
                XCTAssertEqual(errorValue, LocationServiceError.NotAuthorized)
            }
            
            secondExpectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0) { error -> Void in
            XCTAssertNil(error, "Expectation should succeed")
        }
    }
}
