//
//  ModelEntityTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import Parking

class ModelEntityTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLicenseMinskCityPlateParsing() {
        let targetPlate = LicensePlate(region: .RegionMinskCity, seria: "АЕ", number: 1234)
        XCTAssertEqual(targetPlate.string, "1234 АЕ-7")
                
        var parsedPlate = LicensePlate("1234 АЕ-7")
        XCTAssertEqual(targetPlate, parsedPlate)
        
        parsedPlate = LicensePlate("АЕ 1234-7")
        XCTAssertEqual(targetPlate, parsedPlate)
        
        parsedPlate = LicensePlate("АЕ-7 1234")
        XCTAssertEqual(targetPlate, parsedPlate)

        parsedPlate = LicensePlate("А 1234 Е-7")
        XCTAssertEqual(targetPlate, parsedPlate)
    }
    
    func testLicenseMinskRegionPlateParsing() {
        let targetPlate = LicensePlate(region: .RegionMinsk, seria: "АЕ", number: 1234)
        XCTAssertEqual(targetPlate.string, "1234 АЕ-5")
        
        var parsedPlate = LicensePlate("1234 АЕ-5")
        XCTAssertEqual(targetPlate, parsedPlate)
        
        parsedPlate = LicensePlate("АЕ 1234-5")
        XCTAssertEqual(targetPlate, parsedPlate)
        
        parsedPlate = LicensePlate("АЕ-5 1234")
        XCTAssertEqual(targetPlate, parsedPlate)
        
        parsedPlate = LicensePlate("А 1234 Е-5")
        XCTAssertEqual(targetPlate, parsedPlate)
    }
    
    func testInvalidPlateParsing() {
        var parsedPlate = LicensePlate("3245 ІЕ-8")
        XCTAssertNil(parsedPlate)
        
        parsedPlate = LicensePlate("3254 Ю-7")
        XCTAssertNil(parsedPlate)
        
        parsedPlate = LicensePlate("А 1234 -5")
        XCTAssertNil(parsedPlate)
    }
    
    func testReportPlateParsing() {
        let targetPlate = LicensePlate(region: .RegionMinsk, seria: "АЕ", number: 1234)
        XCTAssertEqual(targetPlate.string, "1234 АЕ-5")
        
        let jsonString = "{ \"number\" : \"АЕ-5 1234\" }"
        let report = Mapper<Report>().map(jsonString)
        
        guard let plateValue = report?.licensePlate else {
            XCTFail("Should get non-nil license plate value")
            return
        }
        
        switch plateValue {
        case LicensePlateValue.Seria2004(let plate):
            XCTAssertEqual(targetPlate, plate)
            
        case LicensePlateValue.Custom(_):
            XCTFail("Plate value shouldn't be parsed into custom value")
        }
    }
    
    func testReportCustomPlateParsing() {
        let targetPlate = "7 TAX 1234"
        
        let jsonString = "{ \"number\" : \"\(targetPlate)\" }"
        let report = Mapper<Report>().map(jsonString)
        
        guard let plateValue = report?.licensePlate else {
            XCTFail("Should get non-nil license plate value")
            return
        }
        
        switch plateValue {
        case LicensePlateValue.Seria2004(_):
            XCTFail("Plate value shouldn't be parsed into seria2004 value")
            
        case LicensePlateValue.Custom(let stringPlate):
            XCTAssertEqual(targetPlate, stringPlate)
        }
    }
    
    func testAddressValueCustom() {
        let jsonString = "улица Ангарская, 11-2-77"
        let result = AddressTranform().transformFromJSON(jsonString)
        
        XCTAssertNotNil(result)
        
        switch result! {
        case AddressValue.Full(_):
            XCTFail("Invalid result type")
            
        default:
            break
        }
    }
    
    func testAddressValueFull() {
        let jsonString = "{ \"street\" : \"улица Ангарская\", \"streetNumber\" : \"11-2-77\", \"locality\" : \"Минск\", \"postalCode\" : \"220107\", \"country\" : \"Беларусь\" }"
        
        let result = AddressTranform().transformFromJSON(jsonString)
        
        XCTAssertNotNil(result)
        
        switch result! {
        case AddressValue.Custom(_):
            XCTFail("Invalid result type")
            
        default:
            break
        }
    }
}
