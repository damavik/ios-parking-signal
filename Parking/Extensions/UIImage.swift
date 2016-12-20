//
//  UIImage.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit

extension UIImage {
    func tint(_ color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, 0)
        
        var rect = CGRect.zero
        rect.size = self.size
        
        color.set()
        
        UIRectFill(rect)
        
        self.draw(in: rect, blendMode: .destinationIn, alpha: 1.0)
        
        let result = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return result!
    }
}
