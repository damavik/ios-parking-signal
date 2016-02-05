//
//  UIImage.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

extension UIImage {
    func tint(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        
        var rect = CGRectZero
        rect.size = self.size
        
        color.set()
        
        UIRectFill(rect)
        
        self.drawInRect(rect, blendMode: .DestinationIn, alpha: 1.0)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result
    }
}