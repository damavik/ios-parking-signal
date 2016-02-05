//
//  Address.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/15/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import ObjectMapper

enum AddressValue : Equatable {
    case Full(Address)
    case Custom(String)
}

func ==(first: AddressValue, second: AddressValue) -> Bool {
    switch (first, second) {
    case (.Full(let first), .Full(let second)) where first == second:
        return true
        
    case (.Custom(let first), .Custom(let second)) where first == second:
        return true
        
    default:
        return false
    }
}

struct Address : Mappable, Equatable {
    var postalCode: String?
    var country: String!
    var sublocality: String?
    var locality: String?
    var street: String?
    var streetNumber: String?
    
    init() {
        // Nothing
    }
    
    init?(_ map: Map) {
    }
    
    mutating func mapping(map: Map) {
        self.postalCode <- map["postalCode"]
        self.country <- map["country"]
        self.sublocality <- map["sublocality"]
        self.locality <- map["locality"]
        self.street <- map["street"]
        self.streetNumber <- map["streetNumber"]
    }
}

func ==(first: Address, second: Address) -> Bool {
    return (first.postalCode == second.postalCode
        && first.country == second.country
        && first.sublocality == second.sublocality
        && first.locality == second.locality
        && first.street == second.street
        && first.streetNumber == second.streetNumber)
}