//
//  ReportViewModelTests.swift
//  Parking
//
//  Created by Vital Vinahradau on 1/3/16.
//  Copyright © 2016 Signal. All rights reserved.
//

import XCTest
import ObjectMapper
@testable import Parking

class ReportViewModelTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testModelReset() {
        let model = self.getFilledViewModel()
        model.reset()
        
        XCTAssertNotNil(model)
        
        XCTAssertNil(model.date)
        XCTAssertNil(model.licensePlate)
        XCTAssertNil(model.addressString)
        
        XCTAssertNil(model.reporterName)
        XCTAssertNil(model.reporterEmail)
        XCTAssertNil(model.reporterResidenceAddress)
    }
    
    func testIncompleteModelReport() {
        let model = self.getFilledViewModel()
        model.offense = nil
        model.imageIndexes = []
        
        let report = model.formReport()
        
        XCTAssertNil(report)
    }
    
    func testCompleteModelReport() {
        let model = self.getFilledViewModel()
        model.offense = Offense(JSON: [ "code" : "143.2", "desc" : "Примерный текст нарушения" ])
        model.imageIndexes = [ 1, 3, 4 ]
        
        let report = model.formReport()
        
        XCTAssertNotNil(report)
    }
    
    fileprivate func getFilledViewModel() -> ReportViewModel {
        let result = ReportViewModel.instance
        
        result.date = Date()
        result.licensePlate = "1234 MM-7"
        result.addressString = "улица Ангарская, 11-2-77"
        
        result.reporterName = "Иванов Иван Иванович"
        result.reporterEmail = "ivan@tut.by"
        result.reporterResidenceAddress = "улица Байкальская, 2-17"
        
        return result
    }
}
