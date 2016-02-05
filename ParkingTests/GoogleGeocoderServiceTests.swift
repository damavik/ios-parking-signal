//
//  GoogleGeocoderServiceImplementationTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import XCTest
import CoreLocation
@testable import Parking

class GoogleGeocoderServiceImplementationTests: XCTestCase {
    
    private var googleService: GeocoderService!
    
    override func setUp() {
        super.setUp()
        self.googleService = GoogleGeocoderServiceImplementation(apiKey: "AIzaSyBiDuXOPe6ktbRlilNL4nFAQLarY-aMhvs", networkService: NetworkServiceImplementation())
    }
    
    override func tearDown() {
        self.googleService = nil
        super.tearDown()
    }
    
    func testMinskZavodskiRayon() {
        let expectation = self.expectationWithDescription("reverse-geocoding")
        
        var originalAddress = Address()
        originalAddress.country = "Беларусь"
        originalAddress.locality = "Минск"
        originalAddress.sublocality = "Заводской район"
        originalAddress.street = "улица Байкальская"
        originalAddress.streetNumber = "66/2"
        
        let location = CLLocation(latitude: 53.864505, longitude: 27.6811155)
        self.googleService.fetchAddress(location, language: .Russian) { result -> Void in
            
            switch result {
            case GeocoderServiceResult.Success(let address):
                XCTAssertEqual(originalAddress, address)
                
            default:
                XCTFail("Invalid result")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
    
    func testMinskFrunzenskiRayon() {
        let expectation = self.expectationWithDescription("reverse-geocoding")
        
        var originalAddress = Address()
        originalAddress.country = "Беларусь"
        originalAddress.locality = "Минск"
        originalAddress.sublocality = "Фрунзенский район"
        originalAddress.street = "улица Одинцова"
        originalAddress.streetNumber = "18/1"
        
        let location = CLLocation(latitude: 53.898425, longitude: 27.450153)
        self.googleService.fetchAddress(location, language: .Russian) { result -> Void in
            
            switch result {
            case GeocoderServiceResult.Success(let address):
                XCTAssertEqual(originalAddress, address)
                
            default:
                XCTFail("Invalid result")
            }
            
            expectation.fulfill()
        }
        
        self.waitForExpectationsWithTimeout(5.0, handler: nil)
    }
}
