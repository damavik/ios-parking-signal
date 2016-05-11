//
//  String.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

extension String {
    func subString(startIndex: Int, length: Int) -> String {
        let start = self.startIndex.advancedBy(startIndex)
        let end = self.startIndex.advancedBy(startIndex + length)
        return self.substringWithRange(Range<String.Index>(start ..< end))
    }
}

infix operator =~ {}

func =~(string: String, regex: String) -> Bool {
    return string.rangeOfString(regex, options: .RegularExpressionSearch) != nil
}