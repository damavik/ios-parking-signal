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
            
            return device.hasFlash && device.flashAvailable
        }
    }
    
    var flashEnabled: Bool {
        get {
            guard let device = self.captureDevice else {
                return false
            }
            
            return device.flashMode == .Auto || device.flashMode == .On
        }
        
        set(enabled) {
            if (self.flashAvailable) {
                guard let device = self.captureDevice else {
                    return
                }
                
                do {
                    try device.lockForConfiguration()
                    device.flashMode = enabled ? .Auto : .Off
                    device.unlockForConfiguration()
                } catch {
                    Log("Failed to set flash enabled to value '%d'", enabled)
                }
            } else {
                Log("Failed to set flash enabled to value '%d' for a device without flash available", enabled)
            }
        }
    }
    
    private var captureSession: AVCaptureSession?
    
    private var captureDevice: AVCaptureDevice? {
        get {
            return (self.session?.inputs.last as? AVCaptureDeviceInput)?.device
        }
    }
    
    private lazy var stillImageOutput = AVCaptureStillImageOutput()
    private var captureCallback: (NSError? -> Void)!
    
    override init() {
        super.init()
        self.captureSession = self.startSession(&self.stillImageOutput)
        self.flashEnabled = true
    }
    
    deinit {
        self.session?.stopRunning()
    }
    
    // MARK: PhotoCaptureService
    
    func capturePhoto(completion: NSError? -> Void) -> Void {
        
        if let videoConnection = self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo) {
            Log("Photo capture requested")
            
            self.captureCallback = completion
            
            self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection) {
                imageDataSampleBuffer, error in
                if (error == nil) {
                    Log("Sucessfully captured photo")
                    
                    let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                    let image = UIImage(data: imageData)
                    
                    UIImageWriteToSavedPhotosAlbum(image!,
                                                   self,
                                                   #selector(PhotoCaptureServiceImplementation.image(_:didFinishSavingWithError:contextInfo:)),
                                                   nil)
                } else {
                    Log("Failed to capture photo with error '%@'", error)
                    self.captureCallback!(error)
                    self.captureCallback = nil
                }
            }
        } else {
            Log("Photo capture requested but no connection with suitable media type")
            completion(nil)
        }
    }
    
    private func startSession(inout imageOutput: AVCaptureStillImageOutput) -> AVCaptureSession? {
        Log("Photo capture session start requested")
        
        var captureDevice: AVCaptureDevice?
        
        let devices = AVCaptureDevice.devices()
        
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if (device.position == AVCaptureDevicePosition.Back) {
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
    
    @objc func image(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafePointer<Void>) {
        if let _ = self.captureCallback {
            self.captureCallback!(error)
            self.captureCallback = nil
        }
    }
}