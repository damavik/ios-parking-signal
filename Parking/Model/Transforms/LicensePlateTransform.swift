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
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let stringValue = value as? String else {
            return nil
        }
        
        guard let plate = LicensePlate(stringValue) else {
            return .custom(stringValue)
        }
        
        return .seria2004(plate)
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        guard let plateValue = value else {
            return nil
        }
        
        switch plateValue {
        case .seria2004(let plate):
            return plate.string
            
        case .custom(let string):
            return string
        }
    }
}
