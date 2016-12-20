//
//  AddressManagerTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/21/15.
//  Copyright © 2015 Signal. All rights reserved.
//


import XCTest
import CoreLocation
@testable import Parking

class AddressManagerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLocationMinskAnharskaja() {
        class TestLocationService : LocationService {
            func fetchCurrentLocation(_ callback: @escaping (LocationServiceResult) -> Void) -> Disposable? {
                callback(LocationServiceResult.success(CLLocation(latitude: 53.864505, longitude: 27.6811155)))
                return nil
            }
        }
        
        var targetAddress = Address()
        targetAddress.country = "Беларусь"
        targetAddress.locality = "Минск"
        targetAddress.sublocality = "Заводской район"
        targetAddress.street = "улица Байкальская"
        targetAddress.streetNumber = "66/2"
        
        let expectation = self.expectation(description: "reverse-geocoding")
        
        let manager = AddressManager(locationService: TestLocationService())
        manager.fetchCurrentAddress { result -> Void in
            switch result {
            case AddressManagerResult.success(let address):
                XCTAssertEqual(targetAddress, address)
                
            case AddressManagerResult.failure(_):
                XCTFail("Address should be fetched successfully")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectations(timeout: 5.0) { error -> Void in
            XCTAssertNil(error)
        }
    }
}
