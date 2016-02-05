//
//  AddressTransform.swift
//  Parking
//
//  Created by Vital Vinahradau on 1/17/16.
//  Copyright © 2016 Signal. All rights reserved.
//

import ObjectMapper

struct AddressTranform : TransformType {
    typealias Object = AddressValue
    typealias JSON = String
    
    func transformFromJSON(value: AnyObject?) -> Object? {
        guard let stringValue = value as? String else {
            return nil
        }
        
        if let address = Address(JSONString: stringValue) {
            return .Full(address)
        }
        
        return .Custom(stringValue)
    }
    
    func transformToJSON(value: Object?) -> JSON? {
        guard let addressValue = value else {
            return nil
        }
        
        switch addressValue {
        case .Full(let full):
            return Mapper().toJSONString(full, prettyPrint: true)
            
        case .Custom(let string):
            return string
        }
    }
}