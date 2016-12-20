//
//  ImageCaptureService.swift
//  Parking
//
//  Created by Vital Vinahradau on 12/25/15.
//  Copyright © 2015 Signal. All rights reserved.
//

import AVFoundation
import UIKit

class PhotoCaptureServiceImplementation : NSObject, PhotoCaptureService {
    // MARK: PhotoCaptureService
    
    var session: AVCaptureSession? {
        get {
            return self.captureSession
        }
    }
    
    var flashAvailable: Bool {
        get {
            guard let device = self.captureDevice else {
                return false
            }
            
            return device.hasFlash && device.isFlashAvailable
        }
    }
    
    var flashEnabled: Bool {
        get {
            guard let device = self.captureDevice else {
                return false
            }
            
            return device.flashMode == .auto || device.flashMode == .on
        }
        
        set(enabled) {
            if (self.flashAvailable) {
                guard let device = self.captureDevice else {
                    return
                }
                
                do {
                    try device.lockForConfiguration()
                    device.flashMode = enabled ? .auto : .off
                    device.unlockForConfiguration()
                } catch {
                    Log("Failed to set flash enabled to value '%d'", enabled as CVarArg)
                }
            } else {
                Log("Failed to set flash enabled to value '%d' for a device without flash available", enabled as CVarArg)
            }
        }
    }
    
    fileprivate var captureSession: AVCaptureSession?
    
    fileprivate var captureDevice: AVCaptureDevice? {
        get {
            return (self.session?.inputs.last as? AVCaptureDeviceInput)?.device
        }
    }
    
    fileprivate lazy var stillImageOutput = AVCaptureStillImageOutput()
    fileprivate var captureCallback: ((NSError?) -> Void)!
    
    override init() {
        super.init()
        self.captureSession = self.startSession(&self.stillImageOutput)
        self.flashEnabled = true
    }
    
    deinit {
        self.session?.stopRunning()
    }
    
    // MARK: PhotoCaptureService
    
    func capturePhoto(_ completion: @escaping (NSError?) -> Void) -> Void {
        
        if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            Log("Photo capture requested")
            
            self.captureCallback = completion
            
            self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                imageDataSampleBuffer, error in
                if (error == nil) {
                    Log("Sucessfully captured photo")
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                    let image = UIImage(data: imageData!)
                    
                    UIImageWriteToSavedPhotosAlbum(image!,
                                                   self,
                                                   #selector(PhotoCaptureServiceImplementation.image(_:didFinishSavingWithError:contextInfo:)),
                                                   nil)
                } else {
                    Log("Failed to capture photo with error '%@'", error as! CVarArg)
                    self.captureCallback!(error as NSError?)
                    self.captureCallback = nil
                }
            }
        } else {
            Log("Photo capture requested but no connection with suitable media type")
            completion(nil)
        }
    }
    
    fileprivate func startSession(_ imageOutput: inout AVCaptureStillImageOutput) -> AVCaptureSession? {
        Log("Photo capture session start requested")
        
        var captureDevice: AVCaptureDevice?
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices! {
            // Make sure this particular device supports video
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if ((device as AnyObject).position == AVCaptureDevicePosition.back) {
                    captureDevice = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDevice == nil {
            Log("No suitable capture device found")
            return nil
        }
        
        let session = AVCaptureSession()
        session.sessionPreset = AVCaptureSessionPresetPhoto
        
        do {
            try session.addInput(AVCaptureDeviceInput(device: captureDevice))
        } catch {
            Log("Failed to add device input to capture session")
            return nil
        }
        
        imageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if session.canAddOutput(imageOutput) {
            session.addOutput(imageOutput)
        }
        
        session.startRunning()
        
        return session
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer) {
        if let _ = self.captureCallback {
            self.captureCallback!(error)
            self.captureCallback = nil
        }
    }
}
