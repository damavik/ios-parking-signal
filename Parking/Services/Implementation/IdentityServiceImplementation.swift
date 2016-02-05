//
//  IdentityServiceImplementation.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/29/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

class IdentityServiceImplementation: IdentityService {
    private lazy var defaults = NSUserDefaults.standardUserDefaults()
    
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
    
    private func getStringValue(key: String) -> String? {
        return self.defaults.objectForKey(key) as? String
    }
    
    private func setValue(value: String?, key: String) {
        self.defaults.setObject(value, forKey: key)
        self.defaults.synchronize()
    }
}