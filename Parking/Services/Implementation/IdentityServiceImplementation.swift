//
//  IdentityServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/29/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

class IdentityServiceImplementation: IdentityService {
    fileprivate lazy var defaults = UserDefaults.standard
    
    // MARK: IdentityService
    
    var name: String? {
        get {
            return self.getStringValue("userName")
        }
        
        set(newValue) {
            self.setValue(newValue, key: "userName")
        }
    }
    
    var address: String? {
        get {
            return self.getStringValue("userAddress")
        }
        
        set(newValue) {
            self.setValue(newValue, key: "userAddress")
        }
    }
    
    var email: String? {
        get {
            return self.getStringValue("userEmail")
        }
        
        set(newValue) {
            self.setValue(newValue, key: "userEmail")
        }
    }
    
    // MARK: Utils
    
    fileprivate func getStringValue(_ key: String) -> String? {
        return self.defaults.object(forKey: key) as? String
    }
    
    fileprivate func setValue(_ value: String?, key: String) {
        self.defaults.set(value, forKey: key)
        self.defaults.synchronize()
    }
}
