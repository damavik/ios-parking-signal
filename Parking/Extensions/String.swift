//
//  String.swift
//  Parking
//
//  Created by Vital Vinahradau on 11/22/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import Foundation

extension String {
    func subString(_ startIndex: Int, length: Int) -> String {
        let start = self.characters.index(self.startIndex, offsetBy: startIndex)
        let end = self.characters.index(self.startIndex, offsetBy: startIndex + length)
        return self.substring(with: Range<String.Index>(start ..< end))
    }
}

infix operator =~

func =~(string: String, regex: String) -> Bool {
    return string.range(of: regex, options: .regularExpression) != nil
}
