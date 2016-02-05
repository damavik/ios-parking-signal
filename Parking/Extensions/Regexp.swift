//
//  Regexp.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

infix operator =~ {}

func =~(string: String, regex: String) -> Bool {
    return string.rangeOfString(regex, options: .RegularExpressionSearch) != nil
}