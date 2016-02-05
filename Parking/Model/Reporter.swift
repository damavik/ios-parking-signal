//
//  Reporter.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/20/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import ObjectMapper

struct Reporter : Mappable, Equatable {
    var name: String!
    var email: String!
    var residenceAddress: AddressValue!
    
    init?(_ map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.name <- map["name"]
        self.email <- map["email"]
        self.residenceAddress <- (map["address"], AddressTranform())
    }
}

func ==(first: Reporter, second: Reporter) -> Bool {
    return (first.name == second.name && first.email == second.email && first.residenceAddress == second.residenceAddress)
}