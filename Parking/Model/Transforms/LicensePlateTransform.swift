//
//  LicensePlateTransform.swift
//  Parking
//
//  Created by Vital Vinahradau on 1/17/16.
//  Copyright © 2016 Signal. All rights reserved.
//

import ObjectMapper

struct LicensePlateTranform : TransformType {
    typealias Object = LicensePlateValue
    typealias JSON = String
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let stringValue = value as? String else {
            return nil
        }
        
        guard let plate = LicensePlate(stringValue) else {
            return .Custom(stringValue)
        }
        
        return .Seria2004(plate)
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        guard let plateValue = value else {
            return nil
        }
        
        switch plateValue {
        case .Seria2004(let plate):
            return plate.string
            
        case .Custom(let string):
            return string
        }
    }
}