//
//  Report.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import ObjectMapper

enum LicensePlateValue : Equatable {
    case Seria2004(LicensePlate)
    case Custom(String)
}

func ==(first: LicensePlateValue, second: LicensePlateValue) -> Bool {
    switch (first, second) {
    case (.Seria2004(let first), .Seria2004(let second)) where first == second:
        return true
        
    case (.Custom(let first), .Custom(let second)) where first == second:
        return true
        
    default:
        return false
    }
}

struct Report : Mappable, Equatable {
    var reporter: Reporter!
    var offense: Offense!
    var time: NSDate!
    var licensePlate: LicensePlateValue!
    var address: AddressValue!
    var images: [UIImage]!
    
    init() {
        // Nothing
    }
    
    init?(_ map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.reporter <- map["reporter"]
        self.offense <- map["offense"]
        self.time <- map["time"]
        self.licensePlate <- (map["number"], LicensePlateTranform())
        self.address <- (map["address"], AddressTranform())
    }
}

func ==(first: Report, second: Report) -> Bool {
    return (first.reporter == second.reporter
        && first.offense == second.offense
        && first.time == second.time
        && first.licensePlate == second.licensePlate)
}