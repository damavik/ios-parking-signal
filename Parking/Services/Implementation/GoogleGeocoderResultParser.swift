//
//  GoogleGeocoderResultParser.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/18/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation
import ObjectMapper

struct GoogleGeocoderResultParser {
    
    fileprivate enum AddressComponentType: String {
        case Country = "country"
        case PostalCode = "postal_code"
        case Street = "route"
        case StreetNumber = "street_number"
        case Locality = "locality"
        case Sublocality = "sublocality_level_1"
    }
    
    fileprivate struct AddressComponent : Mappable {
        var longValue: String!
        var shortValue: String!
        var type: AddressComponentType?
        
        init?(map: Map) {
        }
        
        mutating func mapping(map: Map) {
            self.longValue <- map["long_name"]
            self.shortValue <- map["short_name"]
            self.type <- (map["types.0"], TransformOf<AddressComponentType, String>(fromJSON: { AddressComponentType(rawValue: $0 ?? "") }, toJSON: { $0?.rawValue } ))
        }
    }
    
    fileprivate func updateAddress(_ address: inout Address, addressComponent: AddressComponent) {
        if let componentType = addressComponent.type {
            
            switch componentType {
            case .Country:
                address.country = addressComponent.longValue
                
            case .PostalCode:
                address.postalCode = addressComponent.longValue
                
            case .Street:
                address.street = addressComponent.longValue
                
            case .StreetNumber:
                address.streetNumber = addressComponent.longValue
                
            case .Locality:
                address.locality = addressComponent.longValue
                
            case .Sublocality:
                address.sublocality = addressComponent.longValue
            }
        }
    }
    
    func parseAddress(_ result: Dictionary<String, AnyObject>) -> Address? {
        guard let addressComponents = result["address_components"] as? Array<Dictionary<String, AnyObject>> else {
            return nil
        }
        
        let mappedAddressComponents = addressComponents.map { componentDictionary in Mapper<AddressComponent>().map(JSON: componentDictionary) }
        
        let resultAddress = mappedAddressComponents.reduce(Address()) { (address: Address, element: AddressComponent?) -> Address in
            
            guard let addressComponent = element else {
                return address
            }
            
            var result = address
            
            self.updateAddress(&result, addressComponent: addressComponent)
            
            return result
        }
        
        return resultAddress
    }
}
