//
//  LicensePlate.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import ObjectMapper

// 2004 civilian seria

enum LicensePlateRegion : Int {
    case RegionBrest = 1
    case RegionViciebsk = 2
    case RegionHomiel = 3
    case RegionHrodna = 4
    case RegionMinsk = 5
    case RegionMahilieu = 6
    case RegionMinskCity = 7
}

struct LicensePlate : Mappable, Equatable {
    var region: LicensePlateRegion!
    var seria: String!
    var number: UInt!
    var string: String {
        return String(self.number) + " \(self.seria)-" + "\(self.region.rawValue)"
    }
    
    init(region: LicensePlateRegion, seria: String, number: UInt) {
        self.region = region
        self.seria = seria
        self.number = number
    }
    
    init?(_ map: Map) {
    }
    
    init?(_ string: String) {
        let sanitizedString: String = string.stringByReplacingOccurrencesOfString(" ", withString: "")
        
        if sanitizedString =~ "[0-9]{4}[А-Я]{2}-[1-7]{1}" { // 1234 АВ-7
            self.number = UInt(sanitizedString.subString(0, length: 4))
            self.seria = sanitizedString.subString(4, length: 2)
            
            let lastCharacter = sanitizedString.characters.last!
            self.region = LicensePlateRegion(rawValue: lastCharacter.integerValue)
            
            return
        }
        
        if sanitizedString =~ "[А-Я]{2}[0-9]{4}-[1-7]{1}" { // АВ 1234-7
            self.number = UInt(sanitizedString.subString(2, length: 4))
            self.seria = sanitizedString.subString(0, length: 2)
            
            let lastCharacter = sanitizedString.characters.last!
            self.region = LicensePlateRegion(rawValue: lastCharacter.integerValue)
            
            return
        }
        
        if sanitizedString =~ "[А-Я]{2}-[1-7]{1}[0-9]{4}" { // АВ-7 1234
            self.number = UInt(sanitizedString.subString(4, length: 4))
            self.seria = sanitizedString.subString(0, length: 2)
            self.region = LicensePlateRegion(rawValue: sanitizedString[sanitizedString.startIndex.advancedBy(3)].integerValue)
            return
        }
        
        if sanitizedString =~ "[А-Я]{1}[0-9]{4}[А-Я]{1}-[1-7]{1}" { // А1234В-7
            self.number = UInt(sanitizedString.subString(1, length: 4))
            self.seria = String([ sanitizedString[sanitizedString.startIndex], sanitizedString[sanitizedString.startIndex.advancedBy(5)] ])
            
            let lastCharacter = sanitizedString.characters.last!
            self.region = LicensePlateRegion(rawValue: lastCharacter.integerValue)
            
            return
        }
        
        return nil
    }
    
    mutating func mapping(map: Map) {
        self.region <- map["region"]
        self.seria <- map["seria"]
        self.number <- map["number"]
    }
}

func ==(first: LicensePlate, second: LicensePlate) -> Bool {
    return (first.region == second.region && first.seria == second.seria && first.number == second.number)
}