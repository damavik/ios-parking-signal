//
//  StartViewController.swift
//  Parking
//
//  Created by Vital Vinahradau on 6/17/15.
//  Copyright (c) 2015 Vital Vinahradau. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class StartViewController: SignalViewController {

    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var shootButton: UIButton!
    @IBOutlet weak var lastPhotoButton: UIButton!
    
    private lazy var photoStorageService: PhotoStorageService = ServiceFactory.photoStorageService()
    private lazy var photoCaptureService: PhotoCaptureService = ServiceFactory.photoCaptureService()

    private var previewLayer : AVCaptureVideoPreviewLayer!
    
    override func updateViewConstraints() {
        if (!self.didSetupConstraints) {
            self.bottomView.snp_makeConstraints { make in
                make.height.equalTo(90)
                make.width.equalTo(self.view)
                make.centerX.equalTo(self.view)
                make.bottom.equalTo(self.view)
            }
            
            self.flashButton.snp_makeConstraints { make in
                make.size.equalTo(60)
                make.centerY.equalTo(self.bottomView)
                make.left.equalTo(self.bottomView).offset(30)
            }
            
            self.shootButton.snp_makeConstraints { make in
                make.size.equalTo(80)
                make.center.equalTo(self.bottomView)
            }
            
            self.lastPhotoButton.snp_makeConstraints { make in
                make.size.equalTo(60)
                make.centerY.equalTo(self.bottomView)
                make.right.equalTo(self.bottomView).inset(30)
            }
        }
        
        super.updateViewConstraints()
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.flashButton.backgroundColor = UIColor.clearColor()
        self.updateCameraFlashButton()
        
        self.lastPhotoButton.backgroundColor = UIColor.clearColor()
        
        self.photoStorageService.accessStatusChangeCallback = { [weak self] (accessStatus: PhotoStorageServiceAccessStatus) -> Void  in
            if (self == nil) {
                return
            }
            
            self!.updateLastPhotoButton()
        }
        
        guard let captureSession = self.photoCaptureService.session else {
            Log("Failed to initialize photo capture session")
            return
        }
        
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)!
        
        let bounds = self.view.layer.bounds
        
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        self.previewLayer.bounds = bounds
        self.previewLayer.position = CGPointMake(CGRectGetMidX(bounds), CGRectGetMidY(bounds))
        
        self.view.layer.insertSublayer(self.previewLayer, atIndex: 0)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        ReportViewModel.instance.reset()
    }

    override func viewDidLayoutSubviews() {
        self.lastPhotoButton.imageView!.clipsToBounds = true
        self.lastPhotoButton.imageView!.layer.borderWidth = 0
    }
    
    private func updateCameraFlashButton() {
        self.flashButton.hidden = !self.photoCaptureService.flashAvailable
        
        if (!self.flashButton.hidden) {
            if (self.photoCaptureService.flashEnabled) {
                let image = UIImage(named: "camera-flash")
                self.flashButton.setImage(image, forState: UIControlState.Normal)
            } else {
                let image = UIImage(named: "camera-flash")?.tint(UIColor.grayColor())
                self.flashButton.setImage(image, forState: UIControlState.Normal)
            }
        }
    }
    
    private func updateLastPhotoButton() {
        self.photoStorageService.fetchLastPhoto(CGSizeMake(100, 100), callback: { [unowned self] image in
            dispatch_async(dispatch_get_main_queue(), {
                self.lastPhotoButton.setImage(image, forState: UIControlState.Normal)
                self.lastPhotoButton.imageView!.layer.cornerRadius = CGRectGetHeight(self.lastPhotoButton.imageView!.frame) / 2
                
                if (image == nil) {
                    self.lastPhotoButton.setTitle("Продолжить", forState: UIControlState.Normal)
                }
            })
        })
    }
    
    //  MARK: Actions
    
    @IBAction func onShoot(sender: AnyObject) {
        Log("Photo capture initiated")
        
        self.photoCaptureService.capturePhoto { error -> Void in
            if let errorValue = error {
                Log("Photo capture failed with error %@", errorValue)
            } else {
                self.updateLastPhotoButton()
            }
        }
    }
    
    @IBAction func onToggleFlash(sender: AnyObject) {
        Log("Flash toggle initiated with original value %d", self.photoCaptureService.flashEnabled)
        
        self.photoCaptureService.flashEnabled = !self.photoCaptureService.flashEnabled
        self.updateCameraFlashButton()
        
        Log("Flash toggle completed with final value %d", self.photoCaptureService.flashEnabled)
    }
}

