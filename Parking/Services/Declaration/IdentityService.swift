//
//  IdentityService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/29/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

protocol IdentityService {
    var name: String? { get set }
    var address: String? { get set }
    var email: String? { get set }
}