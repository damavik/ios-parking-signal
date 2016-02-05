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
    case DirectionHorizontal
    case DirectionVertical
    case DirectionDiagonalBLTR
    case DirectionDiagonalTLBR
}

extension CAGradientLayer {
    convenience init?(firstColor: UIColor, secondColor: UIColor, direction: LayerShadingDirection) {
        self.init()
        
        let colors = [ firstColor.CGColor, secondColor.CGColor ]
        let locations = [ 0.0, 1.0 ]
        
        self.colors = colors
        self.locations = locations
        
        var startPoint: CGPoint
        var endPoint: CGPoint
        
        switch (direction) {
        case .DirectionVertical:
            startPoint = CGPointMake(0.5,0.0)
            endPoint = CGPointMake(0.5,1.0)
            
        case .DirectionDiagonalBLTR:
            startPoint = CGPointMake(0.0,1.0)
            endPoint = CGPointMake(1.0,0.0)
            
        case .DirectionDiagonalTLBR:
            startPoint = CGPointMake(0.0,0.0)
            endPoint = CGPointMake(1.0,1.0)
            
        default:
            startPoint = CGPointMake(0.0,0.5)
            endPoint = CGPointMake(1.0,0.5)
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