//
//  Integer.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

extension Character {
    var integerValue:Int {
        return Int(String(self)) ?? 0
    }
}