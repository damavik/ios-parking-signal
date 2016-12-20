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
    
    func transformFromJSON(_ value: Any?) -> Object? {
        guard let stringValue = value as? String else {
            return nil
        }
        
        if let address = Address(JSONString: stringValue) {
            return .full(address)
        }
        
        return .custom(stringValue)
    }
    
    func transformToJSON(_ value: Object?) -> JSON? {
        guard let addressValue = value else {
            return nil
        }
        
        switch addressValue {
        case .full(let full):
            return Mapper().toJSONString(full, prettyPrint: true)
            
        case .custom(let string):
            return string
        }
    }
}
