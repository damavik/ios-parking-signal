//
//  Disposable.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/13/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

public protocol Disposable {
    mutating func dispose()
}