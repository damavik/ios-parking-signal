//
//  ReportViewModel.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/27/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

let SendReportRequestNotification = "com.vinahradau.signal.sendreport"

extension Address {
    var stringifiedValue: String {
        // FIXME: review hardcoded street formatting
        
        var result = self.locality ?? ""
        
        if let street = self.street {
            if (result.isEmpty) {
                result = street
            } else {
                result += ", " + street
            }
        }
        
        if let streetNumber = self.streetNumber {
            if (result.isEmpty) {
                result = streetNumber
            } else {
                result += ", " + streetNumber
            }
        }
        
        return result
    }
}

class ReportViewModel {
    static var instance = ReportViewModel()
    
    let dateFormatter: NSDateFormatter
    var date: NSDate!
    
    var licensePlate: String?
    var address: Address?
    var addressString: String?
    var offense: Offense?
    var imageIndexes = [Int]()
    
    var reporterName: String?
    var reporterResidenceAddress: String?
    var reporterEmail: String?
    
    private init() {
        self.dateFormatter = NSDateFormatter()
        self.dateFormatter.dateFormat = "d MMMM, HH:mm"
    }
    
    func reset() -> Void {
        self.licensePlate = nil
        self.address = nil
        self.addressString = nil
        self.date = nil
        self.offense = nil
        self.imageIndexes.removeAll()
        
        self.reporterName = nil
        self.reporterResidenceAddress = nil
        self.reporterEmail = nil
    }
    
    func formReport() -> Report? {
        guard let licensePlateString = self.licensePlate else {
            return nil
        }
        
        guard let reporterNameString = self.reporterName else {
            return nil
        }
        
        guard let reporterEmailString = self.reporterEmail else {
            return nil
        }
        
        guard let reporterAddressString = self.reporterResidenceAddress else {
            return nil
        }
        
        guard let offense = self.offense else {
            return nil
        }
        
        guard let dateTime = self.date else {
            return nil
        }
        
        var addressValue: AddressValue?
        if let address = self.address {
            addressValue = AddressValue.Full(address)
        } else if let addressString = self.addressString {
            addressValue = AddressValue.Custom(addressString)
        }
        
        if (addressValue == nil) {
            return nil
        }
        
        var result = Report()
        result.time = dateTime
        
        result.reporter = Reporter(JSON: [ "name" : reporterNameString, "email" : reporterEmailString, "address" : reporterAddressString ])
        result.offense = offense
        
        if let licensePlate = LicensePlate(licensePlateString) {
            result.licensePlate = LicensePlateValue.Seria2004(licensePlate)
        } else {
            result.licensePlate = LicensePlateValue.Custom(licensePlateString)
        }
        
        result.address = addressValue!
        
        return result
    }
}