//
//  Gradient.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/11/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import UIKit
import SwiftHEXColors

enum LayerShadingDirection {
    case directionHorizontal
    case directionVertical
    case directionDiagonalBLTR
    case directionDiagonalTLBR
}

extension CAGradientLayer {
    convenience init?(firstColor: UIColor, secondColor: UIColor, direction: LayerShadingDirection) {
        self.init()
        
        let colors = [ firstColor.cgColor, secondColor.cgColor ]
        let locations = [ 0.0, 1.0 ]
        
        self.colors = colors
        self.locations = locations as [NSNumber]?
        
        var startPoint: CGPoint
        var endPoint: CGPoint
        
        switch (direction) {
        case .directionVertical:
            startPoint = CGPoint(x: 0.5,y: 0.0)
            endPoint = CGPoint(x: 0.5,y: 1.0)
            
        case .directionDiagonalBLTR:
            startPoint = CGPoint(x: 0.0,y: 1.0)
            endPoint = CGPoint(x: 1.0,y: 0.0)
            
        case .directionDiagonalTLBR:
            startPoint = CGPoint(x: 0.0,y: 0.0)
            endPoint = CGPoint(x: 1.0,y: 1.0)
            
        default:
            startPoint = CGPoint(x: 0.0,y: 0.5)
            endPoint = CGPoint(x: 1.0,y: 0.5)
        }
        
        self.startPoint = startPoint
        self.endPoint = endPoint
    }
    
    convenience init?(firstHex: String, secondHex: String, direction: LayerShadingDirection) {
        let firstColor = UIColor(hexString: firstHex)
        let secondColor = UIColor(hexString: secondHex)
        self.init(firstColor: firstColor!, secondColor: secondColor!, direction: direction)
    }
}
