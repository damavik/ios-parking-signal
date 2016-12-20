//
//  PhotoCaptureService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/26/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import AVFoundation

protocol PhotoCaptureService {
    var session: AVCaptureSession? { get }
    var flashAvailable: Bool { get }
    var flashEnabled: Bool { get set }
    
    func capturePhoto(_ completion: @escaping (NSError?) -> Void) -> Void
}
